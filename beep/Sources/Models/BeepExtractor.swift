import Foundation

enum BeepExtractor {
    // Returns true if a sign-out link is present (user is authenticated)
    static let isLoggedIn = """
    (function() {
        var out = document.querySelector('a[href*="SignOut"], a[href*="signout"]');
        return !!out;
    })()
    """

    // Returns JSON string: { balance, cardNumber, autoLoad }
    static let cardInfoJSON = """
    (function() {
        var balance = null, cardNum = null, autoLoad = false;

        var all = document.querySelectorAll('*');
        for (var i = 0; i < all.length; i++) {
            var el = all[i];
            if (el.children.length > 0) continue;
            var text = el.textContent.trim();
            var cls  = (el.className || '').toString().toLowerCase();
            var eid  = (el.id || '').toLowerCase();
            if (!balance && (cls.includes('balance') || eid.includes('balance') ||
                             cls.includes('stored')  || eid.includes('stored'))) {
                var m = text.match(/\\$[\\d,]+\\.\\d{2}/);
                if (m) balance = m[0];
            }
            if (!cardNum && ((cls.includes('card') && (cls.includes('number') || cls.includes('num'))) ||
                              eid.includes('cardnumber'))) {
                var m2 = text.match(/[\\d ]{16,20}/);
                if (m2) cardNum = m2[0].trim();
            }
        }

        if (!balance) {
            var walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
            var node;
            while ((node = walker.nextNode())) {
                var m3 = node.textContent.match(/\\$[\\d,]+\\.\\d{2}/);
                if (m3 && node.parentElement && node.parentElement.tagName !== 'SCRIPT') {
                    balance = m3[0];
                    break;
                }
            }
        }

        autoLoad = !!document.querySelector('[class*="autoload"][class*="activ"i], [class*="autoload"][class*="enabl"i]');

        return JSON.stringify({ balance: balance, cardNumber: cardNum, autoLoad: autoLoad });
    })()
    """

    // Fills and submits the compasscard.ca login form headlessly
    static func fillLogin(email: String, password: String) -> String {
        let e = email.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "'", with: "\\'")
        let p = password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "'", with: "\\'")
        return """
        (function() {
            var emailField = document.querySelector(
                'input[type="email"], input[id*="Email" i], input[name*="Email" i], input[id*="Username" i]'
            );
            var passField = document.querySelector('input[type="password"]');
            if (!emailField || !passField) return false;
            var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
            setter.call(emailField, '\(e)');
            emailField.dispatchEvent(new Event('input', {bubbles:true}));
            emailField.dispatchEvent(new Event('change', {bubbles:true}));
            setter.call(passField, '\(p)');
            passField.dispatchEvent(new Event('input', {bubbles:true}));
            passField.dispatchEvent(new Event('change', {bubbles:true}));
            var btn = document.querySelector('button[type="submit"], input[type="submit"]');
            if (btn) { btn.click(); return true; }
            var form = emailField.closest('form') || document.querySelector('form');
            if (form) { form.submit(); return true; }
            return false;
        })()
        """
    }

    // Extracts visible error text from the sign-in page after a failed login attempt
    static let loginErrorMessage = """
    (function() {
        var el = document.querySelector(
            '.field-validation-error, [class*="error"i], [class*="alert"i], [class*="validation"i]'
        );
        if (!el) return null;
        var t = el.textContent.trim();
        return t.length > 0 ? t : null;
    })()
    """

    // Returns JSON array: [{ date, location, product, amount, balance }]
    static let tripsJSON = """
    (function() {
        var rows = [];
        document.querySelectorAll('table tbody tr').forEach(function(tr) {
            var cells = tr.querySelectorAll('td');
            if (cells.length >= 3) {
                rows.push({
                    date:     (cells[0] || {textContent:''}).textContent.trim(),
                    location: (cells[1] || {textContent:''}).textContent.trim(),
                    product:  (cells[2] || {textContent:''}).textContent.trim(),
                    amount:   (cells[3] || {textContent:''}).textContent.trim(),
                    balance:  (cells[4] || {textContent:''}).textContent.trim()
                });
            }
        });
        return JSON.stringify(rows);
    })()
    """
}
