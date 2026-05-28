#!/usr/bin/env python3
"""Scrapes UVic mypage for application status and writes uvic-status.json."""

from __future__ import annotations

import json
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

from dotenv import load_dotenv
from playwright.sync_api import sync_playwright, TimeoutError as PWTimeout

ROOT = Path(__file__).parent.parent
load_dotenv(ROOT / ".env")

NETLINK_ID = os.environ.get("UVIC_NETLINK_ID", "joshuatrommel")
STATUS_FILE = ROOT / "uvic-status.json"

CAS_URL = "https://www.uvic.ca/cas/login?service=https%3A%2F%2Fwww.uvic.ca%2Fmypage%2FLogin%3FrefUrl%3D%2Fmypage%2Ff%2Fmy-home%2Fnormal%2Frender.uP"


def get_passphrase() -> str:
    result = subprocess.run(
        ["/usr/bin/security", "find-generic-password", "-s", "uvic-school",
         "-a", NETLINK_ID, "-w"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        sys.exit("Keychain lookup failed. Run: /usr/bin/security add-generic-password "
                 f"-s uvic-school -a {NETLINK_ID} -w <passphrase>")
    return result.stdout.strip()


def find_text(page, selectors: list[str]) -> str | None:
    for sel in selectors:
        try:
            el = page.query_selector(sel)
            if el:
                text = el.inner_text().strip()
                if text:
                    return text
        except Exception:
            pass
    return None


def scrape() -> dict:
    passphrase = get_passphrase()

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(user_agent=(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
            "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
        ))
        page = ctx.new_page()

        # CAS login
        page.goto(CAS_URL, wait_until="networkidle", timeout=30000)
        page.fill('input[name="username"]', NETLINK_ID)
        page.fill('input[name="password"]', passphrase)
        page.click('input[type="submit"], button[type="submit"]')
        # Wait for any navigation away from CAS login
        try:
            page.wait_for_url("**/mypage/**", timeout=20000)
        except PWTimeout:
            # CAS may redirect elsewhere or show an intermediate step
            page.screenshot(path="/tmp/uvic-cas-after-login.png")
            print(f"Post-login URL: {page.url}")
            print("Screenshot saved to /tmp/uvic-cas-after-login.png")
            # Try waiting for any redirect
            page.wait_for_load_state("networkidle", timeout=10000)
            print(f"After networkidle URL: {page.url}")
            if "mypage" not in page.url and "cas" in page.url:
                sys.exit("Still on CAS page — login may have failed or MFA required.")

        admission_status = "Under Review"

        # Dismiss cookie banner if present
        try:
            page.click("button:has-text('Close')", timeout=3000)
        except PWTimeout:
            pass

        # Navigate to Student services > Admissions via Apex
        try:
            page.goto("https://www.uvic.ca/tools/student-services/",
                      wait_until="domcontentloaded", timeout=15000)
            page.screenshot(path="/tmp/uvic-student-services.png")

            # Look for admissions / application link
            for link_text in ["Admission", "Application", "Apex"]:
                el = page.query_selector(f"a:has-text('{link_text}')")
                if el:
                    href = el.get_attribute("href")
                    print(f"Found link '{link_text}': {href}")
                    break
        except PWTimeout:
            pass

        # Try Apex Applications directly (Oracle Apex student portal)
        try:
            page.goto("https://www.uvic.ca/tools/student-services/apex-applications/",
                      wait_until="domcontentloaded", timeout=15000)
            page.screenshot(path="/tmp/uvic-apex.png")
            print(f"Apex URL: {page.url}")
            page.wait_for_load_state("networkidle", timeout=10000)

            found = find_text(page, [
                "*:has-text('Offer of Admission')",
                "*:has-text('Admission Decision')",
                "*:has-text('Application Status')",
                "td:has-text('Admitted')",
                "td:has-text('Conditional')",
                "td:has-text('Pending')",
                "td:has-text('Under Review')",
                "td:has-text('Waitlisted')",
                "td:has-text('Deferred')",
            ])
            if found:
                admission_status = found[:120]
        except PWTimeout:
            pass

        browser.close()

    return {
        "updated": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        "admission": {
            "status": admission_status,
            "program": "BSc Computer Science",
            "student_id": "V01122835",
        },
        "residence": {
            "status": "Application Received",
            "term": "Fall 2026 – Spring 2027",
            "lottery_deadline": "2026-05-15",
            "offers_start": "mid-to-late May 2026",
        },
    }


def git_push():
    os.chdir(ROOT)
    subprocess.run(["git", "add", "uvic-status.json"], check=True)
    result = subprocess.run(
        ["git", "diff", "--cached", "--quiet"], capture_output=True
    )
    if result.returncode == 0:
        print("No change in status — skipping commit.")
        return
    subprocess.run(
        ["git", "commit", "-m", "chore: refresh uvic status"], check=True
    )
    subprocess.run(["git", "push"], check=True)
    print("Pushed uvic-status.json.")


if __name__ == "__main__":
    print(f"Scraping UVic portal as {NETLINK_ID}...")
    data = scrape()
    STATUS_FILE.write_text(json.dumps(data, indent=2) + "\n")
    print(f"Written: {STATUS_FILE}")
    print(json.dumps(data, indent=2))
    git_push()
