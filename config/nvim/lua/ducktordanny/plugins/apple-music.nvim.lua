return {
  "p5quared/apple-music.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    vim.api.nvim_create_user_command("AMSongs", require("apple-music").select_track_telescope, {})
    vim.api.nvim_create_user_command("AMAlbums", require("apple-music").select_album_telescope, {})
    vim.api.nvim_create_user_command("AMPlaylist", require("apple-music").select_playlist_telescope, {})
    vim.api.nvim_create_user_command("AMShuffle", require("apple-music").toggle_shuffle, {})
    vim.api.nvim_create_user_command("AMCleanTempPlaylists", require("apple-music").cleanup_all, {})
    vim.api.nvim_create_user_command("AMFavorite", require("apple-music").favorite_current_track, {})
    vim.api.nvim_create_user_command("AMUnfavorite", require("apple-music").unfavorite_current_track, {})
  end,
}
