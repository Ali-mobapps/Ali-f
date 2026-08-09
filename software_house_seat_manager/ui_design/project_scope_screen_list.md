# Seat Reservation & Management App: Proposed Screen List & Design Direction

## Project Overview
A Flutter-based mobile application for managing seat reservations in a software house. The app facilitates two primary user roles: **Admin (Teachers)** and **Students**, with distinct workflows for seat configuration, registration approval, and daily booking.

---

## Proposed Screen List

### 1. Authentication & Onboarding
- **Login/Signup Screen**: Unified authentication with role selection (Student/Admin).
- **Student Registration Form**: Multi-step form for students to provide details (Name, ID, Department).
- **Registration Pending/Approval State**: A clean "Wait for Admin Approval" feedback screen for students.

### 2. Admin (Teacher) Experience
- **Admin Dashboard**: Overview of today's attendance, available seats, and pending approvals.
- **Seat Management (Configuration)**: Visual editor or list view to define the number of available seats and set daily reservation time limits (e.g., 10:00 AM).
- **Student Approval Queue**: List of pending student registrations with "Approve/Reject" actions.
- **Daily Reports & Analytics**: Detailed reports showing occupancy rates, student lists, and fine history (no-shows).

### 3. Student Experience
- **Student Home/Dashboard**: Current reservation status and quick access to book.
- **Seat Reservation Map**: A visual or grid-based view showing all seats, their availability, and selection logic.
- **Booking Confirmation**: Summary of the reserved seat with check-in instructions and penalty warnings.
- **Profile & History**: View past reservations and any accrued fines for no-shows.

---

## Design Direction

### Visual Style
- **Professional & Modern**: A clean, "Software House" aesthetic using a palette of deep blues, slate grays, and energetic accent colors (e.g., Electric Blue or Mint Green).
- **Clear Hierarchy**: Use of cards and elevated surfaces to separate student details from action buttons.

### Key UI Features
- **Seat Map Component**: Custom painter or grid showing Available (Green), Occupied (Gray), and Selected (Blue) states.
- **Real-time Indicators**: Visual countdowns for the 10:00 AM reservation deadline.
- **Status Badges**: Distinct badges for "Approved," "Pending," and "Fined" states.

### User Experience (UX)
- **Frictionless Approval**: One-tap approval for admins directly from the dashboard notifications.
- **Proactive Alerts**: Push notification reminders for students to check in before they incur a fine.
- **High-Density Reporting**: Clean data tables and simple bar charts (occupancy vs. capacity) for admins.
