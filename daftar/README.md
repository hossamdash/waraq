# Daftar - Hugo Static Site

Daftar is a Hugo-based static site using the PaperMod theme for managing and displaying notes.

## Quick Start

### Prerequisites

- Hugo (extended version recommended)
- Git

### Local Development

```bash
# Start the development server
hugo server
```

The site will be available at `http://localhost:1313`

### Building for Production

```bash
# Build optimized static files
hugo --gc --minify

# Output will be in public/ directory
```

## Project Structure

```
.
├── content/        # Markdown content files
│   └── notes/      # Note entries
├── layouts/        # Custom layout overrides
├── static/         # Static assets (images, etc.)
├── themes/         # PaperMod theme (submodule)
└── hugo.yaml       # Hugo configuration
```

## Configuration

Main configuration is in `hugo.yaml`. See [Hugo documentation](https://gohugo.io/getting-started/configuration/) for available options.

Environment-specific settings can be configured via environment variables prefixed with `HUGO_PARAMS_`.

## Theme

This site uses the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme. See `themes/PaperMod/README.md` for theme-specific features and customization options.

### Updating the Theme

```bash
cd themes/PaperMod
git pull
```

## Adding Content

Create new notes as Markdown files in `content/notes/`:

```bash
hugo new notes/my-new-note.md
```

## Deployment

After building with `hugo --gc --minify`, deploy the `public/` directory to your hosting provider.

## Resources

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Wiki](https://github.com/adityatelange/hugo-PaperMod/wiki)
- [PaperMod Theme README](themes/PaperMod/README.md)
