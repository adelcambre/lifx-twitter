# lifx-twitter 
Some code to update a LIFX light based on twitter messages.

## Usage

1. Register an application with twitter at http://dev.twitter.com/ and get
the consumer secret and key. No need to set a callback URL.
2. Fetch the access credentials for the twitter account for your LIFX. I
   used the `twitter_oauth` gem for a PIN based workflow:
https://github.com/moomerman/twitter_oauth#pin-based-flow
3. Stick the creds in a `credentials.yml` file. It should look something
   like this:

```yaml
twitter:
  consumer_key:        "apps consumer key"
  consumer_secret:     "apps consumer secret"
  access_token:        "user access token"
  access_token_secret: "user secret token"
```

Have fun!


