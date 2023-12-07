## Vetspire Take-home (max 2 hours)

Fork this repo. Build a simple full stack app using frameworks of your choice. Submit your results as a pull request
to this repo with instructions on how to build/run it or, even better, a link to where we can see it already
running/deployed. Alternatively, feel free to send us an archive file of the work.

There is probably more here than can be finished in two hours. Don't worry about completeness. Focus on what's 
important and interesting to you.   

We use `Elixir`, `Ecto`, `Absinthe`, `GraphQL`, `Typescript/Javascript` and `React` at Vetspire but you are welcome to use 
whatever languages and frameworks you prefer.

We encourage you to include a README with notes about your language and framework choices as well as your design 
decisions.

### Features
- Backend API that serves:
    - A list of available dog breeds based on those available in `/images`
    - Individual dog images by breed
- Frontend UI that provides:
    - A list of dog breeds
    - The ability to choose a breed and display the image for it
- Bonus Feature:
  - Ability to add a new breed with a new image


## Usage

Clone this repo locally to run the application. It is actually two applications. One graphQL API and a separate
live view application to interact with the API.

Clone the repo locally.

```
cd ~
git@github.com:hyphenPaul/technical-interview-challenge.git
```

CD into the API an run it first.

```
cd ~/breeds_api
mix setup
mix phx.server
```

Open a new console session and cd into the live view app and run it.

```
cd ~/breeds_api
mix setup
mix phx.server
```

Now navigate to http://localhost:4080
You can see the results coming from the API based on the files in the Breed app assets directory. Try uploading your own jpeg.


## Technical Notes

This experiment was to understand how live view would integrate with a graphQL API
endpoint. I was also curious how graphQL would handle images as I don't have much experience
with how flexible it is. All in all, the result is awkward at best. Having to 
capture the saved file and forward it as another multipart request is klunky. A front-end framework
would handle this much better due to a single trip from the client computer directly to graphQL.

There are zero tests, but I have already pushed the time limits. Everything written here would have
tests obviously.
