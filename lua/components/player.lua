local astal = require("astal")
local Gdk = astal.require("Gdk", "3.0")
local Astal = astal.require("Astal", "3.0")

local bind = astal.bind
local Widget = require("astal.gtk3.widget")
local lookup_icon = Astal.Icon.lookup_icon

local Mpris = astal.require("AstalMpris")

local M = {}

---@param length integer
local function length_str(length)
	local min = math.floor(length / 60)
	local sec = math.floor(length % 60)

	return string.format("%d:%s%d", min, sec < 10 and "0" or "", sec)
end

local function MediaPlayer(player)
	local title = bind(player, "title"):as(function(t)
		return t or "Unknown Track"
	end)

	local artist = bind(player, "artist"):as(function(a)
		return a or "Unknown Artist"
	end)

	local cover_art = bind(player, "cover-art"):as(function(c)
		return string.format("background-image: url('%s');", c)
	end)

	local player_icon = bind(player, "entry"):as(function(e)
		return lookup_icon(e) and e or "audio-x-generic-symbolic"
	end)

	local position = bind(player, "position"):as(function(p)
		return player.length > 0 and p / player.length or 0
	end)

	local play_icon = bind(player, "playback-status"):as(function(s)
		return s == "PLAYING" and "media-playback-pause-symbolic" or "media-playback-start-symbolic"
	end)

	return Widget.Box({
		class_name = "player",
		Widget.Box({
			class_name = "cover-art",
			css = cover_art,
		}),
		Widget.Box({
			vertical = true,
			Widget.Box({
				class_name = "title",
				Widget.Label({
					ellipsize = "END",
					hexpand = true,
					halign = "START",
					label = title,
				}),
				Widget.Icon({
					icon = player_icon,
				}),
			}),
			Widget.Label({
				halign = "START",
				valign = "START",
				class_name = "artist",
				vexpand = true,
				wrap = true,
				label = artist,
			}),
			Widget.Slider({
				visible = bind(player, "length"):as(function(l)
					return l > 0
				end),
				on_dragged = function(event)
					player.position = event.value * player.length
				end,
				value = position,
			}),
			Widget.CenterBox({
				class_name = "actions",
				Widget.Label({
					hexpand = true,
					class_name = "position",
					halign = "START",
					visible = bind(player, "length"):as(function(l)
						return l > 0
					end),
					label = bind(player, "position"):as(length_str),
				}),
				Widget.Box({
					Widget.Button({
						on_clicked = function()
							player:previous()
						end,
						visible = bind(player, "canGoPrevious"),
						Widget.Icon({
							icon = "media-skip-backward-symbolic",
						}),
					}),
					Widget.Button({
						on_clicked = function()
							player:play_pause()
						end,
						visible = bind(player, "canControl"),
						Widget.Icon({
							icon = play_icon,
						}),
					}),
					Widget.Button({
						on_clicked = function()
							player:next()
						end,
						visible = bind(player, "canGoNext"),
						Widget.Icon({
							icon = "media-skip-forward-symbolic",
						}),
					}),
				}),
				Widget.Label({
					class_name = "length",
					hexpand = true,
					halign = "END",
					visible = bind(player, "length"):as(function(l)
						return l > 0
					end),
					label = bind(player, "length"):as(function(l)
						return l > 0 and length_str(l) or "0:00"
					end),
				}),
			}),
		}),
	})
end

M.Player = function()
	local mpris = Mpris.get_default()

	return Widget.Box({
		vertical = true,
		bind(mpris, "players"):as(function(players)
			return Cassiopea.table.map(players, MediaPlayer)
		end),
	})
end

M.SpotifyIndicator = function()
	local mpris = Mpris.get_default()

	return Widget.Revealer({
		transition_duration = 200,
		transition_type = "SLIDE_RIGHT",
		reveal_child = bind(mpris, "players"):as(function(players)
			if players == nil then
				return false
			end

			return Cassiopea.table.find(players, function(player)
				return player.entry == "spotify"
			end)
		end),
		Widget.Button({
			class_name = "spotify-indicator",
			on_clicked = function()
				local player = Cassiopea.table.find(mpris.players, function(player)
					return player.entry == "spotify"
				end)
				if player == nil then
					return
				end

				player:play_pause()
			end,
			on_button_press_event = function(_, event)
				if event.button == Gdk.BUTTON_SECONDARY then
					Cassiopea.niri.focus_window("spotify")
				end
			end,
			Widget.Label({
				label = " ",
			}),
		}),
	})
end

return M
