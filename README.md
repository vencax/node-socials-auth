
# REST server for SPA apps authentication

[![build status](https://api.travis-ci.org/vencax/node-socials-auth.svg)](https://travis-ci.org/vencax/node-socials-auth)

Provides routes for login via social network facilities (facebook, google, ...).
Meant to run with [https://github.com/vencax/node-spa-auth](node-spa-auth).
But can be pluggend into any other express app if apropriate params used.

## Install

	npm install socials-auth --save

## Configuration

Config is performed through few environment variables with obvious meaning:

- FBCLIENTID
- FBCLIENTSECRET
- TWITTERCONSUMERKEY
- TWITTERCONSUMERSECRET
- GOOGLECLIENTID
- GOOGLECLIENTSECRET

Presence of FBCLIENTID variable unlocks facebook authentication.
Similary for TWITTERCONSUMERKEY and GOOGLECLIENTID.

Rest of envvars:

- CLIENTAPPURL: url of client that user is redirected after successful login.
	This is for initializing user info on client side.
- SERVER_SECRET: same meaning like in [https://github.com/vencax/node-spa-auth](node-spa-auth).

## Dependencies

NOTE: user manipulator: see [https://github.com/vencax/node-spa-auth](node-spa-auth) again.
NOTE: if used separately, perform in express app init phase:

```
app.use passport.initialize();
```

## Routes provided

- /facebook : GET, redirects to facebook auth endpoint
- /facebook/callback : GET, called by facebook side
- ... similarily for other social networks auth facilities
- /userinfo: GET, client wants info about user, sends token in URL query to validate its claim. The token is sent to client upon successful login.

If you want to give a feedback, [raise an issue](https://github.com/vencax/node-socials-auth/issues).
