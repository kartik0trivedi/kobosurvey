# KoBo Shiny Dashboard

This repo contains a Shiny app that pulls KoBo Toolbox data and serves it via `shinyapps.io`. Use the checklist below whenever you spin up a similar project.

## 1. Project Secrets (`.Renviron`)

Create a project-level `.Renviron` in the repo root (not tracked by git) with the credentials you need:

```
KOBO_TOKEN=your_kobo_token
KOBO_ASSETID=your_kobo_asset_id
KOBO_HOST=eu.kobotoolbox.org   # use kf.kobotoolbox.org for the default US server
RSCONNECT_ACCOUNT=your_rsconnect_account
RSCONNECT_TOKEN=your_rsconnect_token
RSCONNECT_SECRET=your_rsconnect_secret
```

- Keep `.Renviron` out of version control (already listed in `.gitignore`).
- Update `KOBO_HOST` per region: `eu.kobotoolbox.org` for EU accounts, `kf.kobotoolbox.org` for the default server, etc.
- Restart R or run `readRenviron(".Renviron")` after editing.

## 2. `rsconnect` Bootstrap (`.Rprofile`)

The repo includes a project-level `.Rprofile` that automatically calls `rsconnect::setAccountInfo()` when all three `RSCONNECT_*` variables are present. You normally do not need to change this file—just keep your `.Renviron` values current.

## 3. Local Development

1. Ensure the environment variables above are loaded.
2. Install dependencies (`shiny`, `httr`, `jsonlite`, `DT`, `rsconnect`).
3. Run the app:
   ```r
   source("app.R")
   ```
   or use the RStudio “Run App” button. The app will fetch KoBo data using `fetch_kobo_data()`, which now respects `KOBO_HOST`.

If you get a `404 Not Found`, confirm:
- `KOBO_HOST` matches the region where the form lives.
- `KOBO_ASSETID` is the asset UID from the KoBo URL.
- The token has access to that asset.

## 4. Deploying to shinyapps.io

With the environment variables loaded, you can deploy straight from an R session:

```r
library(rsconnect)
deployApp()
```

The app pulls the KoBo credentials at startup, so no extra changes are required. If you prefer, uncomment the `rsconnect::deployApp()` helper line in `app.R` or run the call manually.

## 5. Extending to New Projects

For another project, duplicate the repo or use it as a template, then:

- Replace the KoBo asset/token in `.Renviron`.
- Adjust `KOBO_HOST` if the project lives on a different KoBo region.
- Update app UI/logic as needed.
- Re-deploy with `deployApp()` (consider using a unique shinyapps.io app name).

Keep the secrets in `.Renviron`, leave `.Rprofile` untouched, and everything should stay portable and secure.
