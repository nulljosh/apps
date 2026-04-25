import mmap, os, fitz

PATCHES = [
    # (pdf_path, page_0idx, anchor_keyword, answer_text)
    # U2
    (
        "/Users/joshua/Documents/School/science/unit 2/BI12_LG_U02_FILLED.pdf",
        13,  # page 14 (0-indexed)
        "Factors That Will Increase Diffusion",
        "concentration gradient, particle size, medium",
    ),
    (
        "/Users/joshua/Documents/School/science/unit 2/BI12_LG_U02_FILLED.pdf",
        15,  # page 16
        "ribosomes",
        "store/transmit genetic info, produce proteins, transport proteins/lipids",
    ),
    (
        "/Users/joshua/Documents/School/science/unit 2/BI12_LG_U02_FILLED.pdf",
        16,  # page 17
        "Testes & adrenal glands",
        "testosterone, cortisol",
    ),
    # U3
    (
        "/Users/joshua/Documents/School/science/unit 3/BI12_LG_U03_FILLED.pdf",
        11,  # page 12
        "Exothalmic goiter",
        "exophthalmos (bulging eyes); enlarged thyroid and protrusion of the eyes",
    ),
    (
        "/Users/joshua/Documents/School/science/unit 3/BI12_LG_U03_FILLED.pdf",
        12,  # page 13
        "non-competitive inhibition",
        "binds allosteric site (NOT active site); changes enzyme shape so substrate cannot bind",
    ),
    (
        "/Users/joshua/Documents/School/science/unit 3/BI12_LG_U03_FILLED.pdf",
        13,  # page 14
        "D. pH:",
        "optimal pH ~7; other pH levels alter enzyme shape and reduce function",
    ),
    # U9
    (
        "/Users/joshua/Documents/School/science/unit 9/BI12_LG_U09_FILLED.pdf",
        6,  # page 7
        "A surge of LH causes",
        "LH surge triggers follicle rupture, releasing secondary oocyte (ovulation)",
    ),
    (
        "/Users/joshua/Documents/School/science/unit 9/BI12_LG_U09_FILLED.pdf",
        10,  # page 11
        "human chorionic gonadotropin",
        "hCG from embryo maintains corpus luteum, sustaining progesterone for pregnancy",
    ),
]


def open_pdf(path):
    import shutil, tempfile
    tmp = tempfile.mktemp(suffix=".pdf")
    shutil.copy2(path, tmp)
    return fitz.open(tmp), tmp


def find_anchor(page, keyword):
    # Try exact page first
    for b in page.get_text("blocks"):
        if keyword.lower() in b[4].lower():
            return fitz.Rect(b[:4])
    return None


def already_inserted(page, anchor_rect, answer_prefix):
    # Check 60px below anchor for existing answer text
    search_rect = fitz.Rect(
        anchor_rect.x0 - 5,
        anchor_rect.y1,
        anchor_rect.x1 + 5,
        anchor_rect.y1 + 60,
    )
    text = page.get_text("text", clip=search_rect).strip()
    return answer_prefix.lower() in text.lower()


def run():
    # Group patches by file so we open each PDF once
    by_file = {}
    for patch in PATCHES:
        path = patch[0]
        by_file.setdefault(path, []).append(patch)

    for path, patches in by_file.items():
        print(f"\n--- {os.path.basename(path)} ---")
        doc, tmp_path = open_pdf(path)

        for _, page_idx, anchor_kw, answer in patches:
            # If not on exact page, search nearby pages (+/- 2)
            anchor = None
            found_page_idx = None
            for offset in [0, 1, -1, 2, -2]:
                pi = page_idx + offset
                if 0 <= pi < len(doc):
                    a = find_anchor(doc[pi], anchor_kw)
                    if a:
                        anchor = a
                        found_page_idx = pi
                        break

            if anchor is None:
                print(f"  SKIP (anchor not found): {anchor_kw!r}")
                continue

            page = doc[found_page_idx]
            prefix = answer[:20]
            if already_inserted(page, anchor, prefix):
                print(f"  SKIP (already present): {answer[:50]}")
                continue

            pt = fitz.Point(anchor.x0, anchor.y1 + 4)
            page.insert_text(pt, answer, fontname="helv", fontsize=8, color=(0, 0, 0.6))
            print(f"  OK page {found_page_idx + 1}: {answer[:60]}")

        out_path = tmp_path + "_out.pdf"
        doc.save(out_path)
        doc.close()
        import shutil
        shutil.move(out_path, path)
        os.remove(tmp_path) if os.path.exists(tmp_path) else None
        print(f"  Saved.")


if __name__ == "__main__":
    run()
