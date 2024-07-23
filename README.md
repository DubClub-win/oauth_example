# DubClub OAuth2.0 Example

This repository is an example Django project that uses DubClub API as an OpenID provider.

The whole setup heavily relies on `django-oauth-toolkit` and `django-allauth` packages so it is strongly advices to get familiar with them first.

## Trying it out locally

Before starting the server, you will need an `.env` file with the following values:

```.env
export DJANGO_DEBUG=1
export DJANGO_SETTINGS_MODULE=example.settings
export DUBCLUB_CLIENT_ID=
export DUBCLUB_CLIENT_SECRET=
export DUBCLUB_OAUTH_SERVER_URL=https://dubclub.win/
```

`DUBCLUB_CLIENT_ID` and `DUBCLUB_CLIENT_SECRET` are crucial for the whole setup. `django-allauth` needs them to configure the DubClub provider. You can get them by contacting someone on the DubClub side.

`DUBCLUB_OAUTH_SERVER_URL` is pretty much optional, but it can be useful because it allows to work with our test environments instead of directly with production.

When you have the `.env` file, create a virtual environment using `venv` or `uv`. Then, install the dependencies from `requirements.txt` file.

With that in place, source your `.env` file and run the commands from the `Makefile`:

```bash
make static
make migrate
make run
```

After that, you should be able to access your server at `localhost:8000`.

If you go to `http://localhost:8000/accounts/dubclub/login/` you should see a simple page (provided by `django-allauth`) that allows you to login via DubClub. When you click continue, you will be redirected to DubClub login page and prompted to authorize your app to get you authenticated. After that you will be redirected back to your local app and new, authenticated session will be created.

On top of that, `SocialAccount` and `SocialToken` instances will be created for your user. You can check that inside Django admin.

## Troubleshooting

### Version mismatch

Both DubClub backend and `dubclub_allauth` package use a `0.54.0` version of the `django-allauth` library. It is important to align with that because newer versions are not fully compatible with the current code. If you cannot register DubClub provider properly, or you have some "null constraint" errors for the auth models, that might be because of the version mismatch.

### Invalid grant

Keep in mind that authorization grants are very short lived. This means that if you try to refresh callback endpoint with the same, valid code you might end up with "invalid grant" error pretty quickly. `django-allauth` is not too verbose when it comes to callback errors, so it might take you a while to realize what the issue is. Don't refresh the callback too often.

### Wrong redirect (callback) url

There are two possible reasons for this kind of error.

Redirect url for your callback endpoint is configured inside DubClub backend. So, the easiest solution is to confirm whether we have it correct for you - there could be a missing trailing slash, etc.

Second possibilty is when you have some proxy (Apache, Nginx) running in front of your app. Django builds the redirect url using the `build_absolute_uri` method of a request object. If your proxy is not configured correctly, Django might end up always using `127.0.0.1` instead of your domain, or will not add the https part.
