# Improve Bill Design

The goal is to modernize and professionalize the bill design across three areas:
1.  **Printed/PDF Bill**: Improve the layout, typography, and structure of the generated PDF.
2.  **On-Screen Bill Details**: Refactor the bottom sheet in the Sales History page for a cleaner, modern look.
3.  **Shared Receipt**: Enhance the text format for WhatsApp/sharing with better formatting and emojis.

## User Review Required

> [!IMPORTANT]
> The printed bill is currently set for `roll80` (thermal printers). I will maintain this format but improve the visual hierarchy.

## Proposed Changes

### Core Utils

#### [MODIFY] [pdf_generator.dart](file:///C:/Users/Kashif%20Computers/Documents/GitHub/ali-f/book_store_app/lib/core/utils/pdf_generator.dart)
- Add store contact info (placeholder) to the header.
- Use better alignment for prices and quantities.
- Add a "Thank you" footer and a dashed line for separation.
- Improve font sizes for better readability on thermal paper.

### Sales History Feature

#### [MODIFY] [sales_history_page.dart](file:///C:/Users/Kashif%20Computers/Documents/GitHub/ali-f/book_store_app/lib/features/sales/presentation/pages/sales_history_page.dart)
- Redesign the `_showBillDetail` bottom sheet.
- Use a "Ticket" style UI for the bill summary.
- Improve the item list layout with better spacing and dividers.
- Enhance the `shareText` with professional formatting.

### POS Feature

#### [MODIFY] [pos_page.dart](file:///C:/Users/Kashif%20Computers/Documents/GitHub/ali-f/book_store_app/lib/features/pos/presentation/pages/pos_page.dart)
- Enhance the `_shareReceipt` text to match the new professional format.

## Verification Plan

### Automated Tests
- Not applicable for UI/PDF layout changes in this context.

### Manual Verification
- Open "Sales History" and view the "Detailed Bill" modal.
- Perform a test sale in "POS" and verify the printed PDF preview.
- Use the "Share" button to see the new WhatsApp message format.
