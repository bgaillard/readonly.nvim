# readonly.nvim

:warning: This plugin is still in development and not ready for use.

A plugin to prevent editing files containing sensible information (passwords, API keys, private keys, etc.).

## Goal

For example suppose you have [Github Copilot](https://github.com/features/copilot) configured in your Neovim install and you edit an SSH private key file. Are you 100% sure your SSH keys are not sent to Github ?

Is it reasonable to have a blind trust with Github privacy ? What if the privacy changes over time and is relaxed ? What if a Github employee inserts a bug in the Copilot source code which leads to an accidental retention of Prompts ? What about a data leak at Github ? A hacker succeeding to steal data on the fly ?

What about other plugins you installed and are testing ? Are you sure they'll not send sensible information remotely when you enter stuffs in your buffers ?

The plugins helps to not worry about all this by marking specific files as "sensible". Then when you try to open those files an error is displayed to indicate you to edit the file using a very basic editor instead.

## Usage

Suppose you would like to protect the following sensible files.

- `~/.aws/config`
- `~/.aws/credentials`
- `~/.ssh/*`
- `~/.secrets.yaml`
- `~/.vault-crypt-files/*`

The following configuration allows to configure the plugin to indicate that those files should never be writable using a standard Neovim call / configuration (i.e launched with the `nvim` command).

```lua
{
  "bgaillard/readonly.nvim",
  config = function()
    require("readonly").setup {
      secured_files = {
        "~/.aws/config",
        "~/.aws/credentials",
        "~/.ssh/*",
        "~/.secrets.yaml",
        "~/.vault-crypt-files/*",
      }
    }
  end,
  lazy = false
}
```

After configuration of the plugin opening the `~/.aws/config` file will display the following floating window.
