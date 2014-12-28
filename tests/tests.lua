local addonName, ns = ...

ns.title = addonName;
ns.testsLoaded = true;

ns.tests = {
	["Utility Stuff"] = {
		["GenerateSetName"] = function()
			wowUnit:assertEquals(ns:GenerateSetName("Test"), "Test (TF)", "Simple set naming works.")
			wowUnit:assertEquals(ns:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped.")
		end
	},
	["Sets"] = {
		["default values"] = function()
			local set = ns.Set()

			-- we are running these tests for a plain set as well as
			-- a set created from default saved variables to make sure they
			-- have the same default settings
			local sets = {ns.Set(), ns.Set.CreateFromSavedVariables(ns.Set.PrepareSavedVariableTable())}

			for _, set in pairs(sets) do
				wowUnit:assertEquals(set:GetName(), "Unknown", "New sets are named 'Unknown'.")
				wowUnit:assertEquals(set:GetEquipmentSetName(), "Unknown (TF)", "Sets have an appropriate equipment set name.")

				wowUnit:isString(set:GetIconTexture(), "A default icon is provided.")
				wowUnit:assert(set:GetIconTexture():sub(1, 16) == "Interface\\Icons\\", "Default icon has the correct texture path.")

				wowUnit:isEmpty(set:GetHardCaps(), "A new set has no hard caps set.")
				wowUnit:isTable(set:GetHardCaps(), "Set:GetHardCaps always returns a table.")
				wowUnit:isNil(set:GetHardCap('FOO'), "Trying to get a non-existant hard cap returns nil.")

				wowUnit:isEmpty(set:GetStatWeights(), "A new set has no stat weights set.")
				wowUnit:isTable(set:GetStatWeights(), "Set:GetStatWeights always returns a table.")
				wowUnit:isNil(set:GetStatWeight('FOO'), "Trying to get a non-existant stat weight returns nil.")

				wowUnit:isEmpty(set:GetForcedItems(), "No items should be forced in a new set.")
				wowUnit:isTable(set:GetForcedItems(), "Set:GetForcedItems always returns a table.")
				wowUnit:assert(not set:IsForcedItem('FOO'), "A non-existant item is not forced.")

				wowUnit:isEmpty(set:GetVirtualItems(), "No virtual items should be available in a new set.")
				wowUnit:isTable(set:GetVirtualItems(), "Set:GetVirtualItems always returns a table.")

				wowUnit:assert(not set:IsDualWieldForced(), "A new set does not enforce dual wielding.")
				wowUnit:assert(not set:IsTitansGripForced(), "A new set does not enforce titan's grip.")
				wowUnit:assert(set:GetDisplayInTooltip(), "A new set is displayed in tooltips by default.")
			end

			set = ns.Set("AName")
			wowUnit:assertEquals(set:GetName(), "AName", "Constructor can take a set name.")
		end,
		["setting values and saved variables"] = function()
			local vars = ns.Set.PrepareSavedVariableTable()

			wowUnit:isTable(vars, "Prepared saved variables are a table of some sorts.")
		end,
	},
	["Calculation"] = {
		setup = function()
		end,
		teardown = function()
		end,
		["trivial case"] = function()
			local set = ns.Set("test")
			local calc = ns.SmartCalculation(set)

			local testID = wowUnit:pauseTesting()
			calc:SetCallback(function()
				wowUnit:resumeTesting(testID)
			end)
			calc:Start()
		end
	}
}