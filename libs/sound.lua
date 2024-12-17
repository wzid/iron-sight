-- Save the original love.audio.play
local originalPlay = love.audio.play

-- Table to keep track of active sources
local activeSources = {}

function love.audio.play(source)
    if type(source) ~= "userdata" or not source:typeOf("Source") then
        error("love.audio.play expects a Source object!")
    end

    -- Check if the source is streaming
    if source:getType() == "stream" then
        -- Play the streaming source directly
        if not source:isPlaying() then
            originalPlay(source)
        end
    else
        -- For static sounds, check if the source is already playing
        if source:isPlaying() then
            -- Clone the source to allow overlapping playback
            local clone = source:clone()
            originalPlay(clone)

            -- Add the clone to the activeSources for cleanup
            table.insert(activeSources, clone)
        else
            -- If not playing, play the original source
            originalPlay(source)
        end
    end

    -- Cleanup finished sources
    CleanupFinishedSources()
end

-- Helper function to clean up inactive sources
function CleanupFinishedSources()
    for i = #activeSources, 1, -1 do
        if not activeSources[i]:isPlaying() then
            table.remove(activeSources, i)
        end
    end
end