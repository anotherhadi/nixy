{
  lib,
  util,
  colorScheme',
  ...
}:
let
  vault_path = "notes/obsidian";
in
{
  vim = {
    notes.obsidian = {
      enable = true;
      setupOpts = {
        mappings = [ ];
        log_level = lib.generators.mkLuaInline "vim.log.levels.ERROR";

        workspaces = [
          {
            name = "personal";
            path = "~/${vault_path}";
          }
        ];
        notes_subdir = "Notes";
        attachments.img_folder = "Assets";
        daily_notes = {
          folder = "Daily";
          date_format = "%Y-%m-%d";
          default_tags = [ "daily-notes" ];
        };

        picker = {
          name = "fzf-lua";
          mappings.new = "<C-x>";
          mappings.insert_link = "<C-l>";
          tag_mappings.tag_note = "<C-x>";
          tag_mappings.insert_tag = "<C-l>";
        };

        # [[this]] type of links
        preferred_link_style = "wiki";

        disable_frontmatter = false;
        note_frontmatter_func =
          lib.generators.mkLuaInline # lua
            ''
              function (note)
                if note.title then
                  note:add_alias(note.title)
                end

                local out = { id = note.id, aliases = note.aliases, tags = note.tags }

                if not note.date then
                  local date = tostring(os.date("%Y-%m-%d"))
                  out.date = date
                end

                if note.title then
                  out.title = note.title
                end

                -- Keep existing items
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                  for k, v in pairs(note.metadata) do
                    out[k] = v
                  end
                end

                return out
              end
            '';

        note_id_func =
          lib.generators.mkLuaInline # lua
            ''
              function(title)
                local name = ""
                if title ~= nil then
                  name = title
                else
                  -- Ask the user for a name
                  name = vim.fn.input("Enter note name: ")
                  if name == "" then
                    -- If no name is given, generate a random one.
                    for _ = 1, 5 do
                      name = name .. string.char(math.random(65, 90))
                    end
                  end
                end
                -- transform the name into a valid file name and append the date in ISO 8601 format
                local suffix = name:gsub(" ", "-"):lower():gsub("[^a-z0-9-æøå]", "")
                return tostring(os.date("%Y%m%dT%H%M")) .. "-" .. suffix
              end
            '';

        follow_url_func =
          lib.generators.mkLuaInline # lua
            ''
              function(url)
                vim.fn.jobstart({"wl-copy", url})
                vim.fn.jobstart({"notify-send", "Copied " .. url .. " to clipboard."})
              end
            '';

        follow_img_func =
          lib.generators.mkLuaInline # lua
            ''
              function(url)
                vim.ui.open(url)
              end
            '';

        attachments = {
          img_name_func =
            lib.generators.mkLuaInline # lua
              ''
                function()
                  return tostring(os.date("%Y%m%dT%H%M")) .. "-"
                end
              '';
        };

        ui.hl_groups = with colorScheme'; {
          ObsidianTodo.fg = base0A;
          ObsidianDone.fg = base0B;
          ObsidianRightArrow.fg = base09;
          # ObsidianTilde.fg = base0F;
          # ObsidianImportant.fg = base08;
          ObsidianBullet.fg = base0D;
          ObsidianRefText.fg = base0E;
          ObsidianExtLinkIcon.fg = base0E;
          ObsidianTag.fg = base0C;
          ObsidianBlockID.fg = base0C;
          ObsidianHighlightText.bg = base0A;
          ObsidianHighlightText.fg = base01;
        };
      };
    };

    highlight =
      with colorScheme';
      lib.mapAttrs' (name: value: lib.nameValuePair "@markup.heading.${name}.markdown" { fg = value; }) {
        "1" = base08;
        "2" = base0A;
        "3" = base0B;
        "4" = base0C;
        "5" = base0D;
        "6" = base0E;
      };

    keymaps = [
      (util.mkKeymap "n" "<leader>od" ":ObsidianToday<cr>" "Daily note")
      (util.mkKeymap "n" "<leader>oD" ":ObsidianDailies<cr>" "Daily note history")

      (util.mkKeymap "n" "<leader>oo" ":ObsidianQuickSwitch<cr>" "Open note")
      (util.mkKeymap "n" "<leader>os" ":ObsidianSearch<cr>" "Search notes")
      (util.mkKeymap "n" "<leader>oa" ":ObsidianOpen<cr>" "Open in app")
      (util.mkKeymap "n" "<leader>or" ":ObsidianRename<cr>" "Rename note")

      (util.mkKeymap "n" "<leader>ob" ":ObsidianBacklinks<cr>" "Backlinks")
      (util.mkKeymap "n" "<leader>ot" ":ObsidianTags<cr>" "Tags")

      (util.mkKeymap "n" "<leader>op" ":ObsidianPasteImg<cr>" "Paste image")
    ];

    utility.images.image-nvim = {
      enable = true;
      setupOpts = {
        backend = "kitty";
        integrations.markdown = {
          enabled = true;
          only_render_image_at_cursor = true;
          download_remote_images = true;
          clear_in_insert_mode = true;
          resolve_image_path =
            lib.generators.mkLuaInline # lua
              ''
                function(document_path, image_path, fallback)
                  if string.find(document_path, "${vault_path}") then
                    return os.getenv("HOME") .. "/${vault_path}/" .. image_path
                  else
                    return fallback(document_path, image_path)
                  end
                end
              '';
        };
      };
    };
  };
}
