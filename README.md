# :lock: readonly.nvim

[![Mentioned in Awesome Neovim](https://awesome.re/mentioned-badge-flat.svg)](https://github.com/rockerBOO/awesome-neovim)

A plugin to secure edition of files containing sensible information (passwords, API keys, private keys, etc.).

You cannot guarantee all your Neovim plugins are 100% secured and do not leak sensible information. 

So do not open your secure file under your standard `nvim` setup!

## :rocket: Goal

Suppose you configured [Github Copilot](https://github.com/features/copilot) in your Neovim install and you edit an SSH private key file. 

Are you 100% sure your SSH keys are not sent to Github?

Is it reasonable to have a blind trust with Github privacy? What if the privacy changes over time and is relaxed? What if a Github employee inserts a bug in the Copilot source code which leads to an accidental retention of Prompts? What about a data leak at Github? A hacker succeeding to steal data on the fly?

What about other plugins you installed and are testing? Are you sure they'll not send sensible information remotely when you enter stuffs in your Neovim buffers?

The readonly.nvim plugin helps to not worry about secure data leaks by marking specific files as "sensible". When you try to open those files they are opened using a read only mode by default and an error is displayed to indicate you to edit the file using a very basic editor (or editor command) instead.

## :zap: Requirements

Just Neovim and the [nvim-notify](https://github.com/rcarriga/nvim-notify) plugin (read the associated [prerequisites](https://github.com/rcarriga/nvim-notify#prerequisites)).

## :pencil: Usage

Suppose you would like to protect the following sensible files.

- `~/.aws/config`
- `~/.aws/credentials`
- `~/.ssh/*`
- `~/.secrets.yaml`
- `~/.vault-crypt-files/*`

The following configures the plugin with the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager (you can obviously use any plugin manager you like). 

It instructs the plugin to indicate that those files should never be writable using a standard Neovim call (i.e launched with the `nvim` command).

```lua
return {
  "bgaillard/readonly.nvim",
  dependencies = {
    "rcarriga/nvim-notify"
  },
  opts = {
    -- see https://neovim.io/doc/user/lua.html#vim.fs.normalize()
    secured_files = {
      "~/%.aws/config",
      "~/%.aws/credentials",
      "~/%.ssh/.",
      "~/%.secrets.yaml",
      "~/%.vault-crypt-files/.",
    }
  },
  lazy = false
}
```

After configuration of the plugin opening the `~/.aws/config` file will display the following floating window.

![readonly.nvim popup](doc/img/readonly.nvim-popup.png "readonly.nvim popup")

## :large_blue_diamond: Pattern matching

The only stuff to configure in the plugin is the `secured_files` array which contains a list of LUA patterns to match specific files and folders.

If you're not comfortable with LUA patterns the most used syntax expressions to match files and folder are the following.

- The `.` (i.e. dot character) is expressed with `%.` ;
- `.` (a dot) represents all characters.

If you need more read the [Patterns section](https://www.lua.org/manual/5.4/manual.html#6.4.1) of the LUA manual.

Also note that the patterns are normalized with the [`vim.fs.normalize()`](https://neovim.io/doc/user/lua.html#vim.fs.normalize()) Neovim function which means that.

- A `~` character at the beginning of a path is expanded to the user's home directory ;
- A `\` character is converted to a forward slash `/` ;
- Environment variables are expanded.
