return {
  "p5quared/apple-music.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local apple_music = require "apple-music"
    vim.api.nvim_create_user_command("AMSongs", apple_music.select_track_telescope, {})
    vim.api.nvim_create_user_command("AMAlbums", apple_music.select_album_telescope, {})
    vim.api.nvim_create_user_command("AMPlaylist", apple_music.select_playlist_telescope, {})
    vim.api.nvim_create_user_command("AMShuffle", apple_music.toggle_shuffle, {})
    vim.api.nvim_create_user_command("AMCleanTempPlaylists", apple_music.cleanup_all, {})
    vim.api.nvim_create_user_command("AMFavorite", apple_music.favorite_current_track, {})
    vim.api.nvim_create_user_command("AMUnfavorite", apple_music.unfavorite_current_track, {})
  end,
}
