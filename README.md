# Faceboom
Welcome to Faceboom, a Ruby on Rails Facebook-like app with features such as creating, liking, saving and commenting on posts, sending friend requests, messaging, and more.

## Features
- Create, like, save, and comment on posts
- Send and accept friend requests
- Real-time messaging with other users (ActionCable)
- Search for and view profiles of other users
- Social login with Facebook

## Getting Started
To get started with Faceboom, you'll need to have [Ruby](https://www.ruby-lang.org/) (3.1.2) and [Rails](https://rubyonrails.org/) (7.0.4) installed on your machine, as well as [Postgres](https://www.postgresql.org/) (14.5). Once you have these dependencies set up, follow these steps:

1. Clone the repository to your local machine:
```
git clone https://github.com/jozef-hudec-27/faceboom.git
```

2. Navigate to the directory:
```
cd faceboom
```

3. Install the necessary gem dependencies:
```
bundle install
```

4. Set up the database:
```
rails db:create
rails db:migrate
```

5. Start the server:
```
rails s
```

6. Visit the app at `http://localhost:3000` in your web browser.

## Contributions
We welcome contributions to Faceboom. If you have an idea for a new feature or have found a bug, please open an issue in the repository.
