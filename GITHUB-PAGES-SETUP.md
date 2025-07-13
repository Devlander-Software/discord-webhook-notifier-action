# GitHub Pages Setup Guide

This guide will help you enable GitHub Pages for your Discord Webhook Notifier Action documentation.

## Prerequisites

- Your repository is public (or you have GitHub Pro for private repos)
- You have admin access to the repository

## Step 1: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll down to **Pages** section (or click **Pages** in the left sidebar)
4. Under **Source**, select **GitHub Actions**
5. Click **Save**

## Step 2: Configure Pages Settings

1. In the **Pages** settings, ensure:
   - **Source**: GitHub Actions
   - **Branch**: Leave as default (GitHub Actions will handle deployment)

## Step 3: Verify Deployment

1. Push your changes to the `main` branch
2. Go to **Actions** tab to monitor the deployment
3. Look for the **Deploy Documentation** workflow
4. Once completed, your site will be available at:
   ```
   https://[your-username].github.io/discord-webhook-notifier-action
   ```

## Step 4: Custom Domain (Optional)

If you want a custom domain:

1. In **Pages** settings, enter your domain in **Custom domain**
2. Add a `CNAME` file to the `docs/` directory with your domain
3. Configure DNS records to point to `[your-username].github.io`

## Step 5: Update Documentation Links

Update the following files with your actual GitHub Pages URL:

1. **README.md**: Update the documentation badge and links
2. **docs/_config.yml**: Update the `url` and `baseurl` settings
3. **package.json**: Update the `homepage` field

## Troubleshooting

### Common Issues

1. **Build Fails**: Check the Actions tab for error messages
2. **Site Not Loading**: Ensure the deployment workflow completed successfully
3. **Missing Styles**: Verify all assets are in the correct locations

### Manual Deployment

If automatic deployment isn't working:

```bash
# Install dependencies
cd docs
bundle install

# Build locally
bundle exec jekyll build

# Test locally
bundle exec jekyll serve
```

### Jekyll Configuration

The documentation uses Jekyll with the following key files:

- `docs/_config.yml`: Main configuration
- `docs/_layouts/default.html`: Page layout template
- `docs/assets/`: CSS and JavaScript files
- `docs/Gemfile`: Ruby dependencies

## Next Steps

Once GitHub Pages is enabled:

1. [Customize the Documentation](docs/customization.html)
2. [Add More Pages](docs/adding-pages.html)
3. [Configure Analytics](docs/analytics.html)
4. [Set Up Search](docs/search.html)

## Support

Need help with GitHub Pages?

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Support](https://support.github.com/) 