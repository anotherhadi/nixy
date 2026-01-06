# SERVER

## Overview

This document describes the architecture and setup of the self-hosted **NixOS server**, which is securely accessible via **a Cloudflare Tunnel**.
The server is designed for private, secure, and easily manageable self-hosting of various services.

![server dashboard](../.github/assets/server_dashboard.png)

## **Why This Setup?**

- **Private & Secure**: Services are only accessible through Cloudflare's access control, preventing exposure to the "public internet".
- **Domain-based Access**: A custom domain maps to the server's tunnel, making service access simple and consistent.
- **Modular & Declarative**: Everything is managed through NixOS modules (except for access control), ensuring reproducibility and easy configuration.

## **Self-Hosted Services**

The server hosts several key applications:

- **NGINX**: Reverse proxy for routing traffic to services via my domain name.
- **AdGuard Home**: A self-hosted DNS ad blocker for network-wide ad and tracker filtering.
- **Glance**: An awesome dashboard! (See the screenshot above)
- **Arr Stack (Radarr, Sonarr, etc.)**: Automated media management tools for handling movies and TV shows. (legaly ofc)
- **Mealie**: A self-hosted recipe manager and meal planner with a clean user interface.
- **Stirling-PDF**: A powerful, locally hosted web application for editing, merging, and converting PDF files.
- **CyberChef**: The "Cyber Swiss Army Knife" for data analysis, decoding, and encryption tasks.
- **Linkding**: A simple, fast, and minimalist bookmark manager.
- **Mazanoke**: A utility service for image processing, specialized in format conversion and downgrading/optimization.
- **Eleakxir**: A private search engine for exploring data wells (parquet files) with a modern web interface.
- **SSH**: Secure remote access configuration for server management. (via browser too)
- **Security related stuff**: Cloudflared, Fail2Ban, Firewall
