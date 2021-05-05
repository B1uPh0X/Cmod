--serverside code for the propgun


    util.AddNetworkString("newVar")

	net.Receive("newVar", function(len, ply)
		ModelSelected = net.ReadString()
	end)


