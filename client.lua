RegisterNetEvent("Misiuniplm")
AddEventHandler("Misiuniplm", function( )
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'manea' , 1)
        Citizen.Wait(0)
            function Initialize(scaleform)
                local scaleform = RequestScaleformMovie(scaleform)
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                PushScaleformMovieFunctionParameterString("~g~Misiuni")
				PushScaleformMovieFunctionParameterString("~w~Ai primit ~g~Ai primit misiuni noi ~w~: ~b~Baga tare si fa-le ~w~!")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "UNDER_THE_BRIDGE", "HUD_AWARDS", 1)
                Citizen.SetTimeout(15500, function()
                    PushScaleformMovieFunction(scaleform, "SHARD_ANIM_OUT")
                    PushScaleformMovieFunctionParameterInt(1)
                    PushScaleformMovieFunctionParameterFloat(0.33)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
                end)
                return scaleform
            end

            scaleform = Initialize("mp_big_message_freemode")

            while true do
                Citizen.Wait(0)
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			end
			
end)
