# README

This README would normally document whatever steps are necessary to get the
application up and running.

# Instructions

    Brian casel :
        - How to use Authentication in ruby on rails 8 ✅
        - Authentication adding Signup Flow & User profiles

Commande Rails :
`rails g authentication` génére l’authentification pour l’app suivi de la commande `rails db:migrate`
`rails active_storage:install` active le stockage sur rails suivi de la commande `rails db:migrate`
`rails instrumental:authentication`

Creation des models : 
bin/rails g model Role name:string:uniq
bin/rails g model UserProfile user:references first_name:string last_name:string display_name:string phone:string avatar_url:string language:string timezone:string country:string city:string
bin/rails g model Cart user:references status:string
bin/rails g model CartItem cart:references product:references quantity:integer
bin/rails g scaffold Product name:string description:text price:decimal active:boolean
bin/rails g migration AddRoleAndUsernameToUsers role:references username:string active:boolean
Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
