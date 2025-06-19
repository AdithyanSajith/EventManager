# Event Management App

A full-featured event management platform built with Ruby on Rails. This app streamlines event organization, registration, ticketing, and reviews for admins, hosts, and participants.

## Features

- **Role-Based Dashboards:** Separate interfaces for Admins, Hosts, and Participants.
- **Event Registration & Ticketing:** Easy event sign-up and ticket generation.
- **Secure Payments:** Integrated payment gateway for hassle-free transactions.
- **Event & Venue Reviews:** Participants can rate and review events and venues.
- **Calendar Integration:** Add events to Google Calendar or download ICS files.
- **Advanced Filtering & Sorting:** Find events by category, location, date, and popularity.
- **Admin Panel:** Manage events, venues, users, and reviews with ActiveAdmin.
- **RESTful API:** Endpoints for events, registrations, payments, and reviews.
- **Responsive UI:** Built with Bootstrap for seamless experience on all devices.

## Tech Stack

- Ruby on Rails
- PostgreSQL
- JavaScript
- Bootstrap
- Devise (Authentication)
- ActiveAdmin (Admin Panel)
- RSpec (Testing)
- Payment Integration (e.g., Stripe/Razorpay)

## Getting Started

1. **Clone the repository:**
   ```
   git clone https://github.com/yourusername/event-management-app.git
   cd event-management-app
   ```

2. **Install dependencies:**
   ```
   bundle install
   yarn install
   ```

3. **Set up the database:**
   ```
   rails db:create db:migrate db:seed
   ```

4. **Run the server:**
   ```
   rails server
   ```

5. **Visit:** `http://localhost:3000`

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.

---

Feel free to reach out or open an issue for feedback and suggestions!