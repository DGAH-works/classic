--[[
	太阳神三国杀武将扩展包·经典再临（AI部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
	武将总数：8
	武将一览：
		1、神将徐元直（强举、无语）
		2、夏侯杰（吓尿、躺枪）
		3、钟会（争功、权计、拜将）＋（野心、自立、排异）
		4、祢衡（语录、怒骂、桀骜）＋（反唇）
		5、十胜郭嘉（十胜）
		6、瑶池仙子（圣洁、弦灵、水碧）＋（水寒、梦归）
		7、南华老仙（移魂、出世、噬魂）
		8、掀桌于吉（幻惑、掀桌）
	所需标记：
		1、@crShuiBiMark（“水碧”标记，来自技能“水碧”）
		2、@crShiShengMark（“致胜”标记，来自技能“十胜”）
]]--
function SmartAI:useSkillCard(card, use)
	local name
	if card:isKindOf("LuaSkillCard") then
		name = "#" .. card:objectName()
	else
		name = card:getClassName()
	end
	if sgs.ai_skill_use_func[name] then
		sgs.ai_skill_use_func[name](card, use, self)
		if use.to then
			if not use.to:isEmpty() and sgs.dynamic_value.damage_card[name] then
				for _, target in sgs.qlist(use.to) do
					if self:damageIsEffective(target) then return end
				end
				use.card = nil
			end
		end
		return
	end
	if self["useCard"..name] then
		self["useCard"..name](self, card, use)
	end
end
--[[****************************************************************
	编号：CCC - 01
	武将：神将徐元直
	称号：神将强辅
	势力：蜀
	性别：男
	体力上限：4勾玉
]]--****************************************************************
--[[
	技能：强举（阶段技）
	描述：你可以弃置至少一张手牌并指定一名角色，你选择一项：1、该角色摸等量的牌；2、该角色获得等量合理的标记。
]]--
--room:askForChoice(source, "crQiangJu", choices, ai_data)
sgs.ai_skill_choice["crQiangJu"] = function(self, choices, data)
	--local target = data:toPlayer()
	return "draw"
end
--QiangJuCard:Play
local qiangju_skill = {
	name = "crQiangJu",
	getTurnUseCard = function(self, inclusive)
		if self.player:isKongcheng() then
			return nil
		elseif self.player:hasUsed("#crQiangJuCard") then
			return nil
		end
		return sgs.Card_Parse("#crQiangJuCard:.:")
	end,
}
table.insert(sgs.ai_skills, qiangju_skill)
sgs.ai_skill_use_func["#crQiangJuCard"] = function(card, use, self)
	local handcards = self.player:getHandcards()
	handcards = sgs.QList2Table(handcards) 
	self:sortByUseValue(handcards, true)
	local amWeak = self:isWeak()
	local hp = self.player:getHp()
	local WontKeepCards = {}
	if self.player:getHp() < 3 then
		local use_slash, keep_jink, keep_anal = false, false, false
		local keep_slash = self.player:getTag("JilveWansha"):toBool()
		for index, c in ipairs(handcards) do
			if isCard("Peach", c, self.player) then
				continue
			elseif isCard("ExNihilo", c, self.player) then
				continue
			end
			local wont_keep = true
			if ( not use_slash ) and isCard("Slash", c, self.player) then
				local dummy_use = {
					isDummy = true,
					to = sgs.SPlayerList(),
				}
				self:useBasicCard(c, dummy_use)
				if dummy_use.card then
					if keep_slash then
						wont_keep = false
					elseif dummy_use.to and dummy_use.to:length() > 1 then
						wont_keep = false
					elseif not amWeak then
						wont_keep = false
					end
					if not wont_keep then
						use_slash = true
					end
				end
			end
			if wont_keep then
				if c:isKindOf("TrickCard") then
					local dummy_use = {
						isDummy = true,
					}
					self:useTrickCard(c, dummy_use)
					if dummy_use.card then
						wont_keep = false
					end
				elseif c:isKindOf("EquipCard") then
					local dummy_use = {
						isDummy = true,
					}
					self:useEquipCard(c, dummy_use)
					if dummy_use.card then
						wont_keep = false
					end
				end
			end
			if ( not keep_jink ) and isCard("Jink", c, self.player) then
				keep_jink = true
				wont_keep = false
			end
			if ( not keep_anal ) and hp <= 1 and isCard("Analeptic", c, self.player) then
				keep_anal = true
				wont_keep = false
			end
			if wont_keep then
				table.insert(WontKeepCards, c)
			end
		end
	end
	if #WontKeepCards == 0 then
		local use_slash_num = 0
		for index, c in ipairs(handcards) do
			if c:isKindOf("Slash") then
				local will_use = false
				if use_slash_num <= sgs.Sanguosha:correctCardTarget(sgs.TargetModSkill_Residue, self.player, c) then
					local dummy_use = { 
						isDummy = true, 
					}
					self:useBasicCard(c, dummy_use)
					if dummy_use.card then
						will_use = true
						use_slash_num = use_slash_num + 1
					end
				end
				if not will_use then 
					table.insert(WontKeepCards, c) 
				end
			end
		end
		local num = self:getCardsNum("Jink") - 1
		if self.player:getArmor() then 
			num = num + 1 
		end
		if num > 0 then
			for index, c in ipairs(handcards) do
				if c:isKindOf("Jink") and num > 0 then
					table.insert(WontKeepCards, c)
					num = num - 1
				end
			end
		end
		for index, c in ipairs(handcards) do
			if c:isKindOf("Weapon") and self.player:getHandcardNum() < 3 then
				table.insert(WontKeepCards, c)
			elseif c:isKindOf("OffensiveHorse") then
				table.insert(WontKeepCards, c)
			elseif c:isKindOf("EquipCard") and self:getSameEquip(c, self.player) then
				table.insert(WontKeepCards, c)
			elseif c:isKindOf("AmazingGrace") then
				table.insert(WontKeepCards, c)
			elseif c:isKindOf("TrickCard") then
				local dummy_use = {
					isDummy = true,
				}
				self:useTrickCard(c, dummy_use)
				if not dummy_use.card then
					table.insert(WontKeepCards, c)
				end
			end
		end
	end
	if #WontKeepCards > 0 then
		for index = #WontKeepCards, 1, -1 do
			local c = WontKeepCards[index]
			if self.player:isJilei(c) then
				table.remove(WontKeepCards, index)
			end
		end
	end
	local count = #WontKeepCards
	if count == 0 then
		return 
	end
	local overflow = self:getOverflow()
	local target = nil
	local throwCount = 0
	local choice = "draw"
	--Mark
	local mode = self.room:getMode()
	if mode == "zombie" then
		local lord = self.room:getLord()
		if lord and self:isFriend(lord) then
			target = lord
			throwCount = count
			choice = "@round"
		end
	end
	local weak_friends = {}
	if not target then
		self:sort(self.friends, "defense")
		for _,friend in ipairs(self.friends) do
			if self:isWeak(friend) then
				table.insert(weak_friends, friend)
			end
		end
		if #weak_friends > 0 then
			for _,friend in ipairs(weak_friends) do
				if friend:hasSkill("fenyong") and friend:getMark("@fenyong") == 0 then
					target = friend
					throwCount = 1
					choice = "@fenyong"
					break
				elseif friend:hasSkill("zhichi") and friend:getMark("@late") == 0 then
					target = friend
					throwCount = 1
					choice = "@late"
					break
				end
			end
		end
	end
	if not target and #weak_friends > 0 then
		local ZhuGeLiang = self.room:findPlayerBySkillName("dawu")
		if ZhuGeLiang then
			for _,friend in ipairs(weak_friends) do
				if friend:getMark("@fog") == 0 then
					target = friend
					throwCount = 1
					choice = "@fog"
					break
				end
			end
		end
	end
	if not target then
		local GuanYu = self.room:findPlayerBySkillName("wuhun")
		if GuanYu and not GuanYu:isLord() then
			self:sort(self.enemies, "threat")
			for _,enemy in ipairs(self.enemies) do
				if enemy:objectName() ~= GuanYu:objectName() then
					target = enemy
					throwCount = count
					choice = "@nightmare"
					break
				end
			end
		end
	end
	if ( not target ) and #weak_friends > 0 then
		for _,friend in ipairs(weak_friends) do
			if friend:hasSkill("fuli") and friend:getMark("@laoji") == 0 then
				target = friend
				throwCount = math.min(count, math.max(1, overflow))
				choice = "@laoji"
				break
			elseif friend:hasSkill("niepan") and friend:getMark("@nirvana") == 0 then
				target = friend
				throwCount = math.min(count, math.max(1, overflow))
				choice = "@nirvana"
				break
			elseif friend:hasSkill("zuixiang") and friend:getMark("@sleep") == 0 then
				target = friend
				throwCount = 1
				choice = "@sleep"
				break
			elseif friend:hasSkill("xiemu") then
				local wei, shu, wu, qun = 0, 0, 0, 0
				for _,enemy in ipairs(self.enemies) do
					local kingdom = enemy:getKingdom()
					if kingdom == "wei" then wei = wei + 1
					elseif kingdom == "shu" then shu = shu + 1
					elseif kingdom == "wu" then wu = wu + 1
					elseif kingdom == "qun" then qun = qun + 1
					end
				end
				if friend:getMark("@xiemu_wei") == 0 and wei >= shu and wei >= wu and wei >= qun then
					target = friend
					throwCount = 1
					choice = "@xiemu_wei"
					break
				elseif friend:getMark("@xiemu_shu") == 0 and shu >= wei and shu >= wu and shu >= qun then
					target = friend
					throwCount = 1
					choice = "@xiemu_shu"
					break
				elseif friend:getMark("@xiemu_wu") == 0 and wu >= wei and wu >= shu and wu >= qun then
					target = friend
					throwCount = 1
					choice = "@xiemu_wu"
					break
				elseif friend:getMark("@xiemu_qun") == 0 then
					target = friend
					throwCount = 1
					choice = "@xiemu_qun"
					break
				end
			end
		end
	end
	if ( not target ) and #weak_friends > 0 then
		local WenPin = self.room:findPlayerBySkillName("zhenwei")
		if WenPin then
			for _,friend in ipairs(weak_friends) do
				if friend:getMark("@defense") == 0 then
					target = friend
					throwCount = 1
					choice = "@defense"
					break
				end
			end
		end
	end
	if ( not target ) and #self.friends_noself > 0 then
		local ZhuGeLiang = self.room:findPlayerBySkillName("kuangfeng")
		if ZhuGeLiang then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getMark("@gale") == 0 then
					target = enemy
					throwCount = 1
					choice = "@gale"
					break
				end
			end
		end
	end
	if not target then
		local ZangBa = self.room:findPlayerBySkillName("hengjiang")
		if ZangBa then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getMark("@hengjiang") == 0 then
					if enemy:objectName() ~= ZangBa:objectName() then
						target = enemy
						throwCount = math.min(count, math.max(1, overflow))
						choice = "@hengjiang"
						break
					end
				end
			end
		end
	end
	if not target then
		for _,friend in ipairs(self.friends) do
			if friend:hasSkill("renjie") then
				target = friend
				throwCount = count
				choice = "@bear"
				break
			elseif friend:hasSkill("kuangbao") then
				target = friend
				throwCount = count
				choice = "@wrath"
				break
			end
		end
	end
	if not target then
		for _,enemy in ipairs(self.enemies) do
			if enemy:hasSkill("kuiwei") and enemy:getMark("@kuiwei") == 0 then
				target = enemy
				throwCount = 1
				choice = "@kuiwei"
				break
			end
		end
	end
	if not target then
		local ChenLin = self.room:findPlayerBySkillName("songci")
		if ChenLin and self:isEnemy(ChenLin) then
			for _,friend in ipairs(self.friends) do
				if friend:getMark("@songci") == 0 then
					target = friend
					throwCount = 1
					choice = "@songci"
					break
				end
			end
			if not target then
				for _,enemy in ipairs(self.enemies) do
					if enemy:getMark("@songci") == 0 then
						target = enemy
						throwCount = 1
						choice = "@songci"
						break
					end
				end
			end
		end
	end
	if not target then
		for _,friend in ipairs(self.friends) do
			if friend:hasSkill("xiongyi") and friend:getMark("@arise") == 0 then
				target, choice = friend, "@arise"
				break
			elseif friend:hasSkill("fencheng") and friend:getMark("@burn") == 0 then
				target, choice = friend, "@burn"
				break
			elseif friend:hasSkill("luanwu") and friend:getMark("@chaos") == 0 then
				target, choice = friend, "@chaos"
				break
			elseif friend:hasSkill("fenwei") and friend:getMark("@fenwei") == 0 then
				target, choice = friend, "@fenwei"
				break
			elseif friend:hasSkill("yeyan") and friend:getMark("@flame") == 0 then
				target, choice = friend, "@flame"
				break
			elseif friend:hasSkill("xiancheng") and friend:getMark("@handover") == 0 then
				target, choice = friend, "@handover"
				break
			elseif friend:hasSkill("zhongyi") and friend:getMark("@loyal") == 0 then
				target, choice = friend, "@loyal"
				break
			elseif friend:hasSkill("nosfencheng") and friend:getMark("@nosburn") == 0 then
				target, choice = friend, "@nosburn"
				break
			elseif friend:hasSkill("jiefan") and friend:getMark("@rescue") == 0 then
				target, choice = friend, "@rescue"
				break
			elseif friend:hasSkill("tishen") and friend:getMark("@substitute") == 0 then
				target, choice = friend, "@substitute"
				break
			elseif friend:hasSkill("xiechan") and friend:getMark("@twine") == 0 then
				target, choice = friend, "@twine"
				break
			end
		end
		if target then
			throwCount = count
		end
	end
	--Draw
	if not target then
		target = self:findPlayerToDraw(true, count) or self.player
		throwCount = count
		choice = "draw"
	end
	if target and throwCount > 0 then
		local to_use = {}
		self:sortByKeepValue(WontKeepCards)
		for index = 1, throwCount, 1 do
			local c = WontKeepCards[index]
			local id = c:getEffectiveId()
			table.insert(to_use, id)
		end
		local card_str = "#crQiangJuCard:"..table.concat(to_use, "+")..":->"..target:objectName()
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
		if use.to then
			use.to:append(target)
		end
		sgs.ai_skill_choice["crQiangJu"] = choice
	end
end
--相关信息
sgs.ai_choicemade_filter["skillChoice"].crQiangJu = function(self, player, promptlist)
	local data = player:getTag("crQiangJuTarget")
	local target = data:toPlayer()
	if target then
		local choice = promptlist[#promptlist]
		local intention = 0
		if choice == "draw" then
			intention = -50
			if target:isKongcheng() and self:needKongcheng(target) then
				intention = 0
			elseif target:hasSkill("manjuan") and target:getPhase() == sgs.Player_NotActive then
				intention = 0
			end
		else
			local ignore_marks = "@burnheart|@struggle"
			local bad_marks = "@hengjiang|@kuiwei|@nightmare"
			if string.match(bad_marks, choice) then
				intention = 40
			elseif string.match(ignore_marks, choice) then
				intention = 0
			elseif choice == "@songci" then
				local ChenLin = self.room:findPlayerBySkillName("songci")
				if ChenLin then
					target = ChenLin
					intention = 30
				end
			else
				intention = -10
			end
		end
		if intention ~= 0 then
			sgs.updateIntention(player, target, intention)
		end
	end
end
--[[
	技能：无语
	描述：结束阶段开始时，若你于本回合内未造成过伤害，你可以一项：1、弃置场上一枚合理的标记；2、摸两张牌。
]]--
--room:askForPlayerChosen(player, targets, "crWuYu", "@crWuYu", true)
sgs.ai_skill_playerchosen["crWuYu"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		elseif self:isEnemy(p) then
			table.insert(enemies, p)
		end
	end
	if #enemies > 0 then
		for _,enemy in ipairs(enemies) do
			if enemy:getMark("@round") > 0 then
				sgs.ai_skill_choice["crWuYu"] = "@round"
				return enemy
			end
		end
		self:sort(enemies, "defense")
		if #self.friends_noself > 0 then
			local marks = "@defense|@fenyong|@fog|@late"
			marks = marks:split("|")
			for _,enemy in ipairs(enemies) do
				for _,mark in ipairs(marks) do
					if enemy:getMark(mark) > 0 then
						sgs.ai_skill_choice["crWuYu"] = mark
						return enemy
					end
				end
			end
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		local wuhun_targets = self:getWuhunRevengeTargets()
		if #wuhun_targets > 0 then
			for _,p in ipairs(wuhun_targets) do
				for _,friend in ipairs(friends) do
					if p:objectName() == friend:objectName() and friend:getMark("@nightmare") > 0 then
						sgs.ai_skill_choice["crWuYu"] = "@nightmare"
						return friend
					end
				end
			end
		end
		local marks = "@hengjiang|@gale|@kuiwei"
		marks = marks:split("|")
		for _,friend in ipairs(friends) do
			for _,mark in ipairs(marks) do
				if friend:getMark(mark) > 0 then
					sgs.ai_skill_choice["crWuYu"] = mark
					return friend
				end
			end
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		local marks = "@arise|@burn|@chaos|@fenwei|@flame|@handover|@loyal|@nosburn|@rescue|@substitute|@twine"
		marks = marks:split("|")
		for _,enemy in ipairs(enemies) do
			for _,mark in ipairs(marks) do
				if enemy:getMark(mark) > 0 then
					sgs.ai_skill_choice["crWuYu"] = mark
					return enemy
				end
			end
		end
		marks = "@laoji|@nirvana|@sleep|@xiemu_qun|@xiemu_shu|@xiemu_wei|@xiemu_wu"
		marks = marks:split("|")
		for _,enemy in ipairs(enemies) do
			for _,mark in ipairs(marks) do
				if enemy:getMark(mark) > 0 then
					sgs.ai_skill_choice["crWuYu"] = mark
					return enemy
				end
			end
		end
	end
	local ChenLin = self.room:findPlayerBySkillName("songci")
	if ChenLin and self:isFriend(ChenLin) then
		if #friends > 0 then
			for _,friend in ipairs(friends) do
				if friend:getMark("@songci") > 0 then
					sgs.ai_skill_choice["crWuYu"] = "@songci"
					return friend
				end
			end
		end
		if #enemies > 0 then
			for _,enemy in ipairs(enemies) do
				if enemy:getMark("@songci") > 0 then
					sgs.ai_skill_choice["crWuYu"] = "@songci"
					return enemy
				end
			end
		end
	end
	if #enemies > 0 then
		for _,enemy in ipairs(enemies) do
			if enemy:getMark("@bear") == 4 and enemy:getMark("baiyin") == 0 then
				sgs.ai_skill_choice["crWuYu"] = "@bear"
				return enemy
			elseif enemy:getMark("@wrath") == 6 and not self:willSkipPlayPhase(enemy) then
				sgs.ai_skill_choice["crWuYu"] = "@wrath"
				return enemy
			end
		end
	end
	sgs.ai_skill_choice["crWuYu"] = "cancel"
	return nil
end
--room:askForChoice(player, "crWuYu", choices, ai_data)
sgs.ai_skill_choice["crWuYu"] = function(self, choices, data)
	--local target = data:toPlayer()
	return "cancel"
end
--player:askForSkillInvoke("crWuYu-draw", data)
sgs.ai_skill_invoke["crWuYu_draw"] = true
--相关信息
sgs.ai_choicemade_filter["skillChoice"].crWuYu = function(self, player, promptlist)
	local data = player:getTag("crWuYuTarget")
	local target = data:toPlayer()
	if target then
		local choice = promptlist[#promptlist]
		local intention = 0
		local ignore_marks = "@burnheart|@struggle"
		local bad_marks = "@hengjiang|@kuiwei|@nightmare"
		if choice == "cancel" then
			intention = 0
		elseif string.match(bad_marks, choice) then
			intention = -40
		elseif string.match(ignore_marks, choice) then
			intention = 0
		elseif choice == "@songci" then
			local ChenLin = self.room:findPlayerBySkillName("songci")
			if ChenLin then
				target = ChenLin
				intention = -10
			end
		else
			intention = 30
		end
		if intention ~= 0 then
			sgs.updateIntention(player, target, intention)
		end
	end
end
--[[****************************************************************
	编号：CCC - 02
	武将：夏侯杰
	称号：套马的汉子
	势力：魏
	性别：男
	体力上限：3勾玉
]]--****************************************************************
--[[
	技能：吓尿（锁定技）
	描述：一名其他角色造成伤害时，若你在其攻击范围内，你弃置所有手牌并摸X张牌（X为该角色的体力）。
]]--
--[[
	技能：躺枪（锁定技）
	描述：杀死你的角色失去1点体力上限并获得技能“躺枪”。
]]--
--[[****************************************************************
	编号：CCC - 03
	武将：钟会
	称号：桀骜的野心家
	势力：魏
	性别：男
	体力上限：3勾玉
]]--****************************************************************
--[[
	技能：争功
	描述：你受到一次伤害时，你可以将伤害来源装备区中的一张牌置入你的装备区。
]]--
--player:askForSkillInvoke("crZhengGong", data)
sgs.ai_skill_invoke["crZhengGong"] = function(self, data)
	local damage = data:toDamage()
	local source = damage.from
	if self:isFriend(source) then
		if source:getArmor() and self:needToThrowArmor(source) then
			return true
		end
	end
	if self:hasSkills(sgs.lose_equip_skill, source) and self:isWeak() then
		return false
	end
	local better = false
	local weapon, my_weapon = source:getWeapon(), self.player:getWeapon()
	if weapon then
		if my_weapon then
			if self:evaluateWeapon(weapon, self.player) > self:evaluateWeapon(my_weapon, self.player) then
				better = true
			end
		else
			if self:evaluateWeapon(weapon, self.player) > 0 then
				better = true
			end
		end
	end
	local armor, my_armor = source:getArmor(), self.player:getArmor()
	if armor and not better then
		if my_armor then
			if self:evaluateArmor(armor, self.player) > self:evaluateArmor(my_armor, self.player) then
				better = true
			end
		else
			if self:evaluateArmor(armor, self.player) > 0 then
				better = true
			end
		end
	end
	local dhorse, my_dhorse = source:getDefensiveHorse(), self.player:getDefensiveHorse()
	if dhorse and not better then
		better = true
	end
	local ohorse, my_ohorse = source:getOffensiveHorse(), self.player:getOffensiveHorse()
	if ohorse and not better then
		if my_ohorse then
			if not my_ohorse:isKindOf("Monkey") then
				better = true
			end
		else
			better = true
		end
	end
	local treasure, my_treasure = source:getTreasure(), self.player:getTreasure()
	if treasure and not better then
		better = true
	end
	if better then
		return true
	end
	return false
end
--room:askForCardChosen(player, source, "e", "crZhengGong")
--相关信息
sgs.ai_choicemade_filter["cardChosen"].crZhengGong = sgs.ai_choicemade_filter["cardChosen"].fankui
--[[
	技能：权计
	描述：其他角色的回合开始前，你可以与其拼点。若你赢，该角色跳过准备阶段和判定阶段。
]]--
--source:askForSkillInvoke("crQuanJi", ai_data)
sgs.ai_skill_invoke["crQuanJi"] = function(self, data)
	local target = data:toPlayer()
	sgs.cr_quanji_ignore = nil
	local mode = self.room:getMode()
	local ignore = true
	--可无条件发动的技能
	local skills = "luoshen|guanxing|qianxi|xiansi|super_guanxing" --.."|dongcha"
	if self:hasSkills(skills, target) then
		ignore = false
	end
	--英魂
	if ignore and target:hasSkill("yinghun") and target:getLostHp() > 0 then
		ignore = false
	end
	--神智
	if ignore and target:hasSkill("shenzhi") and target:getLostHp() > 0 then
		if target:getHandcardNum() >= target:getLostHp() then
			ignore = false
		end
	end
	--秘计
	if ignore and target:hasSkill("nosmiji") and target:getLostHp() > 0 then
		ignore = false
	end
	--五灵
	if ignore and target:hasSkill("wuling") then
		if target:getMark("@wind") == 0 and target:getMark("@fire") == 0 and target:getMark("@thunder") == 0 then
			if target:getMark("@earth") == 0 and target:getMark("@water") == 0 then
				ignore = false
			end
		end
	end
	--连理
	if ignore and target:hasSkill("lianli") and target:getMark("@tie") == 0 then
		ignore = false
	end
	--替身
	if ignore and target:hasSkill("tishen") and target:getMark("@substitute") > 0 then
		local lastHp = target:property("tishen_hp"):toInt() 
		if lastHp > target:getHp() then
			ignore = false
		end
	end
	--勤学
	if ignore and target:hasSkill("qinxue") and target:getMark("qinxue") == 0 then
		local count = sgs.Sanguosha:getPlayerCount(mode)
		local extra = target:getHandcardNum() - target:getHp()
		if count >= 7 then
			if extra >= 2 then
				ignore = false
			end
		else
			if extra >= 3 then
				ignore = false
			end
		end
		if target:hasSkill("gongxin") then
			ignore = true
		end
	end
	--凿险
	if ignore and target:hasSkill("zaoxian") and target:getMark("zaoxian") == 0 then
		if target:getPile("field"):length() >= 3 then
			ignore = false
		end
		if target:hasSkill("jixi") then
			ignore = true
		end
	end
	--志继
	if ignore and target:hasSkill("zhiji") and target:getMark("zhiji") == 0 then
		if target:isKongcheng() then
			ignore = false
		end
	end
	--若愚
	if ignore and target:hasLordSkill("ruoyu") and target:getMark("ruoyu") == 0 then
		local others = self.room:getOtherPlayers(target)
		local minHp = true
		for _,p in sgs.qlist(others) do
			if p:getHp() < target:getHp() then
				minHp = false
				break
			end
		end
		if minHp then
			ignore = false
		end
	end	
	--魂姿
	if ignore and target:hasSkill("hunzi") and target:getMark("hunzi") == 0 then
		if target:getHp() == 1 then
			ignore = false
		end
		if target:hasSkill("yingzi") and target:hasSkill("yinghun") then
			ignore = true
		end
	end
	--拜印
	if ignore and target:hasSkill("baiyin") and target:getMark("baiyin") == 0 then
		if target:getMark("@bear") >= 4 then
			ignore = false
		end
		if target:hasSkill("jilve") then
			ignore = true
		end
	end
	--自立
	if ignore and target:hasSkill("zili") and target:getMark("zili") == 0 then
		if target:getPile("power") >= 3 then
			ignore = false
		end
	end
	--单骑
	if ignore and target:hasSkill("danji") and target:getMark("danji") == 0 then
		if target:getHandcardNum() > target:getHp() then
			local lord = self.room:getLord()
			if lord then
				if string.find(lord:getGeneralName(), "caocao") then
					ignore = false
				elseif string.find(lord:getGeneral2Name(), "caocao") then
					ignore = false
				end
			end
			if target:hasSkill("mashu") then
				ignore = true
			end
		end
	end
	--绝地
	if ignore and target:hasSkill("juedi") and not target:getPile("yinbing"):isEmpty() then
		ignore = false
	end
	--举义
	if ignore and target:hasSkill("juyi") and target:getMark("juyi") == 0 then
		if target:isWounded() and target:getMaxHp() >= self.room:alivePlayerCount() then
			ignore = false
		end
	end
	--炙日
	if ignore and target:hasSkill("zhiri") and target:getMark("zhiri") == 0 then
		if target:getPile("burn") >= 3 then
			ignore = false
		end
		if target:hasSkill("xintan") then
			ignore = true
		end
	end
	--闺秀
	if ignore and target:hasSkill("guixiu") and target:getMark("guixiu") > 0 then
		ignore = false
	end
	--返乡
	if ignore and target:hasSkill("fanxiang") and target:getMark("fanxiang") == 0 then
		local wake = false
		local alives = self.room:getAlivePlayers()
		for _,p in sgs.qlist(alives) do
			if p:isWounded() and p:getMark("@liangzhu_draw") > 0 then
				wake = true
				break
			end
		end
		if wake then
			ignore = false
		end
	end
	--单骑
	if ignore and target:hasSkill("jspdanqi") and target:getMark("jspdanqi") == 0 then
		if target:getHandcardNum() > target:getHp() then
			local lord = self.room:getLord()
			if lord then
				if string.find(lord:getGeneralName(), "liubei") then
				elseif string.find(lord:getGeneralName(), "liubei") then
				else
					ignore = false
				end
			end
			if target:hasSkill("mashu") and target:hasSkill("nuzhan") then
				ignore = true
			end
		end
	end
	--克构
	if ignore and target:hasSkill("kegou") and target:getMark("kegou") == 0 then
		if target:getKingdom() == "wu" and not target:isLord() then
			local wake = true
			local others = self.room:getOtherPlayers(target)
			for _,p in sgs.qlist(others) do
				if p:getKingdom() == "wu" and not p:isLord() then
					wake = false
					break
				end
			end
			if wake then
				ignore = false
			end
			if target:hasSkill("lianying") then
				ignore = true
			end
		end
	end
	if ignore then
		if mode == "JianGeDefense" then
			local JianGeSkills = "jgxuanlei|jgfengxing|jgtunshi|jgbiantian|jgzhinang|jgbenlei"
			if self:hasSkills(JianGeSkills, target) then
				ignore = false
			end
		elseif mode == "BossMode" then
			local BossSkills = "bossluolei|bossguihuo|bossxixing|bossmodao"
			if self:hasSkills(BossSkills, target) then
				ignore = false
			end
		end
	end
	local invoke = false
	if self:isFriend(target) then
		if ignore and not target:containsTrick("YanxiaoCard") then
			if target:containsTrick("indulgence") then
				local finalRetrial, wizard = self:getFinalRetrial(target, "indulgence")
				if finalRetrial == 1 then
					invoke = false
				elseif self:getOverflow() > 0 then
					invoke = true
				end
			end
			if target:containsTrick("supply_shortage") then
				local finalRetrial, wizard = self:getFinalRetrial(target, "supply_shortage")
				if finalRetrial == 1 then
					invoke = false
				elseif target:isKongcheng() and self:needKongcheng(target) then
					invoke = false
				elseif target:hasSkill("yongsi") then
					invoke = true
				elseif target:hasSkill("tiandu") then
					invoke = false
				else
					invoke = true
				end
			end
			if target:containsTrick("lightning") then
				local finalRetrial, wizard = self:getFinalRetrial(target, "lightning")
				if finalRetrial == 2 then
					invoke = true
				end
			end
		end
	else
		if not ignore then
			invoke = true
		elseif self:hasSkills(sgs.cardneed_skill, target) then
			if self:getOverflow() > 0 then
				invoke = true
			end
		end
	end
	if invoke then
		sgs.cr_quanji_ignore = ignore
		return true
	end
	return false
end
--source:pindian(player, "crQuanJi")
--相关信息
sgs.ai_choicemade_filter["skillInvoke"].crQuanJi = function(self, player, promptlist)
	local choice = promptlist[#promptlist]
	if choice == "yes" then
		local target = self.room:getCurrent()
		if target and target:objectName() ~= player:objectName() then
			local intention = 80
			if not target:containsTrick("YanxiaoCard") then
				if target:containsTrick("indulgence") or target:containsTrick("supply_shortage") then
					intention = -20
				elseif target:containsTrick("lightning") then
					intention = 0
				end
			end
			if intention ~= 0 then
				sgs.updateIntention(player, target, intention)
			end
		end
	end
end
--[[
	技能：拜将（觉醒技）
	描述：准备阶段开始时，若你装备区的牌为三张或更多时，你增加1点体力上限，失去技能“权计”和“争功”，获得技能“野心”。
]]--
--[[
	技能：野心
	描述：你造成或受到一次伤害时，你可以将牌堆顶的一张牌置于你的武将牌上，称为“权”。
		阶段技，你可以用至少一张手牌交换等量的“权”。
]]--
--room:askForAG(source, card_ids, false, "crYeXin")
--YeXinCard:Play
local yexin_skill = {
	name = "crYeXin",
	getTurnUseCard = function(self, inclusive)
		if self.player:isKongcheng() then
			return nil
		elseif self.player:getPile("crYeXinPile"):isEmpty() then
			return nil
		elseif self.player:hasUsed("#crYeXinCard") then
			return nil
		end
		return sgs.Card_Parse("#crYeXinCard:.:")
	end,
}
table.insert(sgs.ai_skills, yexin_skill)
sgs.ai_skill_use_func["#crYeXinCard"] = function(card, use, self)
	local handcards = self.player:getHandcards()
	local ids = {}
	for _,c in sgs.qlist(handcards) do
		local id = c:getEffectiveId()
		table.insert(ids, id)
	end
	local card_str = "#crYeXinCard:"..table.concat(ids, "+")..":"
	local acard = sgs.Card_Parse(card_str)
	use.card = acard
end
--player:askForSkillInvoke("crYeXin", data)
sgs.ai_skill_invoke["crYeXin"] = true
--[[
	技能：自立（觉醒技）
	描述：准备阶段开始时，若“权”的数目为四张或更多，你失去1点体力上限，获得技能“排异”。
]]--
--[[
	技能：排异
	描述：回合结束阶段开始时，你可以将一张“权”置入一个合理的区域。若该区域不为你的区域，你可以摸一张牌。
]]--
--player:askForSkillInvoke("crPaiYi", data)
sgs.ai_skill_invoke["crPaiYi"] = true
--room:askForAG(player, pile, true, "crPaiYi")
--room:askForPlayerChosen(player, alives, "crPaiYi", prompt, true)
sgs.ai_skill_playerchosen["crPaiYi"] = function(self, targets)
	local id = self.player:getMark("crPaiYiID")
	if id > 0 then
		local card = sgs.Sanguosha:getCard(id)
		if card:isKindOf("DelayedTrick") then
			if #self.enemies > 0 then
				if card:isKindOf("Indulgence") or card:isKindOf("SupplyShortage") then
					self:sort(self.enemies, "threat")
					for _,enemy in ipairs(self.enemies) do
						if not enemy:containsTrick("YanxiaoCard") then
							if not enemy:containsTrick(card:objectName()) then
								if targets:contains(enemy) then
									return enemy
								end
							end
						end
					end
				end
			end
		elseif card:isKindOf("EquipCard") then
			self:sort(self.friends, "defense")
			for _,friend in ipairs(self.friends) do
				if not self:getSameEquip(card, friend) then
					if card:isKindOf("Armor") and self:evaluateArmor(card, friend) <= 0 then
					elseif card:isKindOf("Weapon") and self:evaluateWeapon(card, friend) <= 0 then
					else
						return friend
					end
				end
			end
		end
		local the_card, target = self:getCardNeedPlayer({card}, true)
		if target then
			return target
		end
	end
end
--room:askForChoice(player, "crPaiYi", choices, ai_data)
sgs.ai_skill_choice["crPaiYi"] = function(self, choices, data)
	local target = data:toPlayer()
	local id = self.player:getMark("crPaiYiID")
	local card = sgs.Sanguosha:getCard(id)
	local withEquip = string.match(choices, "equip")
	local withJudge = string.match(choices, "trick")
	if target and self:isFriend(target) then
		if withEquip then
			if card:isKindOf("Weapon") then
				if self:evaluateWeapon(card, target) > 0 then
					return "equip"
				else
					return "hand"
				end
			elseif card:isKindOf("Armor") then
				if self:evaluateArmor(card, target) > 0 then
					return "equip"
				else
					return "hand"
				end
			elseif card:isKindOf("EquipCard") then
				return "equip"
			end
		end
		if withJudge then
			if target:containsTrick("YanxiaoCard") then
				if self:willSkipPlayPhase(target) then
					return "trick"
				elseif target:isKongcheng() and self:needKongcheng(target) then
					return "trick"
				end
			end
		end
	else
		if withEquip then
			if card:isKindOf("Weapon") then
				if self:evaluateWeapon(card, target) < 0 then
					return "equip"
				end
			elseif card:isKindOf("Armor") then
				if self:evaluateArmor(card, target) < 0 then
					return "equip"
				end
			end
		end
		if withJudge then
			if not target:containsTrick("YanxiaoCard") then
				if card:isKindOf("Indulgence") or card:isKindOf("SupplyShortage") then
					return "trick"
				elseif card:isKindOf("Lightning") then
					if self:getFinalRetrial(target, "lightning") ~= 2 then
						return "trick"
					end
				end
			end
		end
	end
	return "hand"
end
--player:askForSkillInvoke("crPaiYiDraw", data)
sgs.ai_skill_invoke["crPaiYiDraw"] = true
--相关信息
sgs.ai_choicemade_filter["skillChoice"].crPaiYi = function(self, player, promptlist)
	local data = player:getTag("crPaiYiTarget")
	local target = data:toPlayer()
	if target and target:objectName() ~= player:objectName() then
		local id = player:getMark("crPaiYiID")
		local card = sgs.Sanguosha:getCard(id)
		local choice = promptlist[#promptlist]
		local intention = 0
		if choice == "hand" then
			intention = -50
			if target:isKongcheng() and self:needKongcheng(target) then
				intention = 0
			end
		elseif choice == "equip" then
			intention = -60
			if card then
				if card:isKindOf("Weapon") then
					if self:evaluateWeapon(card, target) < 0 then
						intention = 0
					end
				elseif card:isKindOf("Armor") then
					if self:evaluateArmor(card, target) < 0 then
						intention = 10
					end
				end
			end
		elseif choice == "trick" then
			if card then
				if target:containsTrick("YanxiaoCard") then
					intention = -50
				elseif card:isKindOf("SupplyShortage") or card:isKindOf("Indulgence") then
					intention = 70
				end
			end
		end
		if intention ~= 0 then
			sgs.updateIntention(player, target, intention)
		end
	end
end
--[[****************************************************************
	编号：CCC - 04
	武将：祢衡
	称号：孤胆愤青
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
sgs.yulu_info = {}
sgs.yulu_value = {}
--[[
	技能：语录
	描述：出牌阶段，你可以将2~5张手牌按一定顺序移出游戏作为语录的词汇。
	（经典模式：黑桃视为〖日〗，红桃视为〖我〗，梅花视为〖妹〗，方片视为〖你〗）
	（纯洁模式：黑桃视为〖伴〗，红桃视为〖酱〗，梅花视为〖香〗，方片视为〖卤〗）
	附注：根据原版代码，此技能的实际效果为——
		出牌阶段，你可以将至少一张手牌按一定顺序置于你的武将牌上，称为“词汇”。
]]--
--YuLuCard:Play
local yulu_skill = {
	name = "crYuLu",
	getTurnUseCard = function(self, inclusive)
		if self.player:isKongcheng() then
			return nil
		end
		return sgs.Card_Parse("#crYuLuCard:.:")
	end,
}
table.insert(sgs.ai_skills, yulu_skill)
sgs.ai_skill_use_func["#crYuLuCard"] = function(card, use, self)
	local handcards = self.player:getHandcards()
	local spades, hearts, clubs, diamonds = {}, {}, {}, {}
	for _,c in sgs.qlist(handcards) do
		local suit = c:getSuit()
		if suit == sgs.Card_Spade then
			table.insert(spades, c)
		elseif suit == sgs.Card_Heart then
			table.insert(hearts, c)
		elseif suit == sgs.Card_Club then
			table.insert(clubs, c)
		elseif suit == sgs.Card_Diamond then
			table.insert(diamonds, c)
		end
	end
	local h_spade, h_heart, h_club, h_diamond = #spades, #hearts, #clubs, #diamonds
	local pile = self.player:getPile("crYuLuPile")
	local cmd = {}
	local p_spade, p_heart, p_club, p_diamond = 0, 0, 0, 0
	for _,id in sgs.qlist(pile) do
		local c = sgs.Sanguosha:getCard(id)
		local suit = c:getSuit()
		if suit == sgs.Card_Spade then
			table.insert(cmd, "spade")
			p_spade = p_spade + 1
		elseif suit == sgs.Card_Heart then
			table.insert(cmd, "heart")
			p_heart = p_heart + 1
		elseif suit == sgs.Card_Club then
			table.insert(cmd, "club")
			p_club = p_club + 1
		elseif suit == sgs.Card_Diamond then
			table.insert(cmd, "diamond")
			p_diamond = p_diamond + 1
		end
	end
	local n_spade = h_spade + p_spade
	local n_heart = h_heart + p_heart
	local n_club = h_club + p_club
	local n_diamond = h_diamond + p_diamond
	local n_total = n_spade + n_heart + n_club + n_diamond
	local prefix = table.concat(cmd, "+")
	local effects = {}
	for index, info in ipairs(sgs.yulu_info) do
		if type(info) == "table" then
			local benefit = info["benefit"] or true
			if not benefit then
				continue
			end
			local mark = info["mark"]
			if type(mark) == "string" and self.player:getMark(mark) > 0 then
				continue
			end
			local command = info["command"] 
			if type(command) == "string" then
				local start = string.find(command, prefix)
				if start and start == 1 then
				else
					continue
				end
			end
			local total = info["total"] 
			if type(total) == "number" then
				if n_total < total then
					continue
				end
			end
			local spadeNum = info["spade"] or 0
			if n_spade < spadeNum then
				continue
			end
			local heartNum = info["heart"] or 0
			if n_heart < heartNum then
				continue
			end
			local clubNum = info["club"] or 0
			if n_club < clubNum then
				continue
			end
			local diamondNum = info["diamond"] or 0
			if n_diamond < diamondNum then
				continue
			end
			table.insert(effects, index)
		end
	end
	if #effects == 0 then
		return 
	end
	local isWeak = self:isWeak()
	local maxValue, maxIndex = 0, nil
	for _,index in ipairs(effects) do
		local callback = sgs.yulu_value[index]
		if type(callback) == "function" then
			local value = callback(self, isWeak) or 0
			if value > maxValue then
				maxValue = value
				maxIndex = index
			end
		end
	end
	if maxValue <= 0 then
		return 
	end
	local to_use = {}
	local info = sgs.yulu_info[maxIndex]
	local command = info["command"]
	if type(command) == "string" then
		command = command:split("+")
		if h_spade > 0 and ( info["spade"] or 0 ) > 0 then
			self:sortByKeepValue(spades)
		end
		if h_heart > 0 and ( info["heart"] or 0 ) > 0 then
			self:sortByKeepValue(hearts)
		end
		if h_club > 0 and ( info["club"] or 0 ) > 0 then
			self:sortByKeepValue(clubs)
		end
		if h_diamond > 0 and ( info["diamond"] or 0 ) > 0 then
			self:sortByKeepValue(diamonds)
		end
		for index = #cmd + 1, #command, 1 do
			local suit = command[index]
			if suit == "spade" then
				assert(#spades > 0)
				table.insert(to_use, spades[1]:getEffectiveId())
				table.remove(spades, 1)
			elseif suit == "heart" then
				assert(#hearts > 0)
				table.insert(to_use, hearts[1]:getEffectiveId())
				table.remove(hearts, 1)
			elseif suit == "club" then
				assert(#clubs > 0)
				table.insert(to_use, clubs[1]:getEffectiveId())
				table.remove(clubs, 1)
			elseif suit == "diamond" then
				assert(#diamonds > 0)
				table.insert(to_use, diamonds[1]:getEffectiveId())
				table.remove(diamonds, 1)
			end
		end
	else
		local total = info["total"]
		if type(total) == "number" then
			local p_total = pile:length()
			local count = total - p_total
			if count > 0 then
				handcards = sgs.QList2Table(handcards)
				self:sortByKeepValue(handcards)
				for i=1, count, 1 do
					table.insert(to_use, handcards[i]:getEffectiveId())
				end
			end
		end
	end
	if #to_use > 0 then
		local card_str = "#crYuLuCard:"..table.concat(to_use, "+")..":"
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
	end
end
--room:askForChoice(player, "crYuLu", "nos+neo", data)
sgs.ai_skill_choice["crYuLu"] = "neo"
--[[
	技能：怒骂
	描述：回合结束阶段，你可以大声朗读（使用）当前语录（见详解）。
]]--
--room:askForAG(source, pile, true, "crNuMa")
--NuMaViewCard:Play
--player:askForSkillInvoke("crNuMa", data)
sgs.ai_skill_invoke["crNuMa"] = function(self, data)
	local pile = self.player:getPile("crYuLuPile")
	local count = pile:length()
	if count >= 2 and count <= 5 then
		return true
	end
	return false
end
--room:askForPlayerChosen(player, victims, "crNuMa_Case02", "@crNuMa_Case02", true)
sgs.ai_skill_playerchosen["crNuMa_Case02"] = function(self, targets)
	return self:findPlayerToDiscard("he", true, true, targets, false)
end
--room:askForDiscard(victim, "crNuMa_Case02", 2, 2, false, true)
--room:askForPlayerChosen(player, targets, "crNuMa_Case03", "@crNuMa_Case03", true)
sgs.ai_skill_playerchosen["crNuMa_Case03"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	self:sort(friends, "defense")
	for _,friend in ipairs(friends) do
		if friend:containsTrick("YanxiaoCard") then
			continue
		elseif friend:containsTrick("indulgence") or friend:containsTrick("supply_shortage") then
			return friend
		end
		if friend:containsTrick("lightning") then
			local finalRetrial, wizard = self:getFinalRetrial(friend, "lightning")
			if finalRetrial == 2 then
				return friend
			end
		end
	end
	for _,enemy in ipairs(enemies) do
		if enemy:containsTrick("YanxiaoCard") then
			return enemy
		elseif enemy:containsTrick("lightning") then
			local finalRetrial, wizard = self:getFinalRetrial(enemy, "lightning") 
			if finalRetrial == 2 then
				return enemy
			end
		end
	end
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case04", "@crNuMa_Case04", true)
sgs.ai_skill_playerchosen["crNuMa_Case04"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		for _,friend in ipairs(self.friends) do
			if self:isWeak(friend) > 0 then
				return friend
			end
		end
		for _,friend in ipairs(self.friends) do
			if self:getOverflow(friend) > 0 then
				return friend
			end
		end
	end
	if #enemies > 0 then
		self:sort(friends, "handcard")
		for _,enemy in ipairs(self.friends) do
			if enemy:getHp() >= getBestHp(enemy) then
				if not enemy:hasSkill("tuntian") then
					return enemy
				end
			end
		end
	end
end
--room:askForCardShow(target, player, "crNuMa_Case04")
--room:askForPlayerChosen(player, targets, "crNuMa_Case06", "@crNuMa_Case06", true)
sgs.ai_skill_playerchosen["crNuMa_Case06"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		return friends[1]
	end
	if self:isWeak() then
		self:sort(enemies, "defense")
		enemies = sgs.reverse(enemies)
		for _,enemy in ipairs(enemies) do
			if not self:hasSkills(sgs.masochism_skill, enemy) then
				return enemy
			end
		end
	end
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case07", "@crNuMa_Case07", true)
sgs.ai_skill_playerchosen["crNuMa_Case07"] = sgs.ai_skill_playerchosen["crNuMa_Case06"]
--room:askForPlayerChosen(player, targets, "crNuMa_Case08", "@crNuMa_Case08", true)
sgs.ai_skill_playerchosen["crNuMa_Case08"] = function(self, targets)
	local enemies = {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			table.insert(enemies, p)
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		for _,enemy in ipairs(enemies) do
			if self:isTiaoxinTarget(enemy) then
				return enemy
			end
		end
	end
end
--room:askForUseSlashTo(target, player, prompt, true, true)
--room:askForPlayerChosen(player, alives, "crNuMa_Case09", "@crNuMa_Case09", true)
sgs.ai_skill_playerchosen["crNuMa_Case09"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			if p:getHp() < getBestHp(p) then
				table.insert(friends, p)
			end
		else
			table.insert(enemies, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		for _,friend in ipairs(friends) do
			if friend:getHp() < self.player:getHp() then
				return friend
			end
		end
		if self:needToLoseHp() then
			return friends[1]
		end
	end
end
--room:askForPlayerChosen(player, alives, "crNuMa_Case11", prompt, true)
sgs.ai_skill_playerchosen["crNuMa_Case11"] = function(self, targets)
	local x = self.player:getLostHp()
	self:sort(self.friends, "defense")
	for _,friend in ipairs(self.friends) do
		if not self:toTurnOver(friend, x, "crNuMa") then
			return friend
		end
	end
	if #self.enemies == 0 then
		return 
	end
	self:sort(self.enemies, "threat")
	for _,enemy in ipairs(self.enemies) do
		if self:toTurnOver(enemy, x, "crNuMa") then
			return enemy
		end
	end
end
--room:askForPlayerChosen(player, alives, "crNuMa_Case12", "@crNuMa_Case12", true)
sgs.ai_skill_playerchosen["crNuMa_Case12"] = function(self, targets)
	local friends = {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		for _,friend in ipairs(friends) do
			if not hasManjuanEffect(friend) then
				return friend
			end
		end
	end
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case13", "@crNuMa_Case13", true)
sgs.ai_skill_playerchosen["crNuMa_Case13"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		for _,friend in ipairs(friends) do
			if friend:getArmor() and self:needToThrowArmor(friend) then
				if friend:getEquips():length() == 1 then
					return friend
				end
			end
		end
	end
	if #enemies > 0 then
		local values = {}
		local function getValue(enemy)
			local v = 0
			local equips = enemy:getEquips()
			local count = equips:length()
			if count > 0 then
				v = v + count * 5
				if count == 1 then
					if enemy:getArmor() and self:needToThrowArmor(enemy) then
						v = v - 10
					end
				end
				if self:hasSkills(sgs.lose_equip_skill, enemy) then
					v = v - 10
				end
				local dangerous = self:getDangerousCard(enemy)
				if dangerous and dangerous:isEquipped() then
					v = v + 4
				end
				local valuable = self:getValuableCard(enemy)
				if valuable and valuable:isEquipped() then
					v = v + 3
				end
				if enemy:getArmor() then
					v = v + 2
				end
				if enemy:getDefensiveHorse() then
					v = v + 1.8
				end
				if enemy:getWeapon() then
					v = v + 1.5
				end
				if enemy:getOffensiveHorse() then
					v = v + 0.9
				end
				if enemy:getTreasure() then
					v = v + 1.2
				end
				if self:isWeak(enemy) then
					v = v + 1
				end
			end
			return v
		end
		for _,enemy in ipairs(enemies) do
			values[enemy:objectName()] = getValue(enemy) or 0
		end
		local compare_func = function(a, b)
			local valueA = values[a:objectName()] or 0
			local valueB = values[b:objectName()] or 0
			return valueA > valueB
		end
		table.sort(enemies, compare_func)
		local target = enemies[1]
		local value = values[target:objectName()] or 0
		if value > 0 then
			return target
		end
	end
end
--room:askForPlayerChosen(player, alives, "crNuMa_Case14", "@crNuMa_Case14", true)
sgs.ai_skill_playerchosen["crNuMa_Case14"] = function(self, targets)
	local callback = sgs.ai_skill_use["@@fangquan"]
	if type(callback) == "function" then
		local card_str = callback(self, "@fangquan")
		if card_str and card_str ~= "." then
			local name = card_str:split("->")[2]
			if type(name) == "string" then
				for _,p in sgs.qlist(targets) do
					if p:objectName() == name then
						return p
					end
				end
			end
		end
	end
	local friends = {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		end
	end
	if #friends > 0 then
		self:sort(friends, "threat")
		return friends[1]
	end
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case15", prompt, true)
sgs.ai_skill_playerchosen["crNuMa_Case15"] = sgs.ai_skill_playerchosen["zero_as_slash"]
--room:askForPlayerChosen(player, targets, "crNuMa_Case16", "@crNuMa_Case16", true)
sgs.ai_skill_playerchosen["crNuMa_Case16"] = sgs.ai_skill_playerchosen["zero_as_slash"]
--room:askForUseCard(player, "@@crNuMa", "@crNuMa_Case18")
sgs.ai_skill_use["@@crNuMa"] = function(self, prompt, method)
	local source, target = nil, nil
	if #self.enemies > 0 then
		self:sort(self.enemies, "handcard")
		self.enemies = sgs.reverse(self.enemies)
		for _,enemy in ipairs(self.enemies) do
			if not enemy:isKongcheng() then
				target = enemy
				break
			end
		end
	end
	if target then
		self:sort(self.friends, "threat")
		source = self.friends[1]
	end
	if source and target then
		local card_str = "#NuMaCard:.:->"..source:objectName().."+"..target:objectName()
		return card_str
	end
	return "."
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case21", "@crNuMa_Case21", true)
sgs.ai_skill_playerchosen["crNuMa_Case21"] = function(self, targets)
	local enemies = {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			table.insert(enemies, p)
		end
	end
	if #enemies == 0 then
		return nil
	end
	self:sort(enemies, "handcard")
	for _, enemy in ipairs(self.enemies) do
		if enemy:getCards("he"):length() >= 4 then
			if not self:doNotDiscard(enemy, "nil", true, 4) then
				return enemy
			end
		end
	end
	enemies = sgs.reverse(enemies)
	for _, enemy in ipairs(enemies) do
		if not enemy:isNude() then
			if not (self:hasSkills(sgs.lose_equip_skill, enemy) and enemy:getCards("e"):length() > 0) then
				if not self:needToThrowArmor(enemy) then
					if not enemy:hasSkills("tuntian+zaoxian") then
						return enemy
					end
				end
			end
		end
	end
	for _, enemy in ipairs(enemies) do
		if not enemy:isNude() then
			if not (self:hasSkills(sgs.lose_equip_skill, enemy) and enemy:getCards("e"):length() > 0) then
				if not self:needToThrowArmor(enemy) then
					return enemy
				end
			end
		end
	end
end
--room:askForCardChosen(player, target, "he", "crNuMa_Case21")
--room:askForPlayerChosen(player, alives, "crNuMa_Case22", "@crNuMa_Case22", true)
sgs.ai_skill_playerchosen["crNuMa_Case22"] = function(self, targets)
	local values = {}
	local JinXuanDi = self.room:findPlayerBySkillName("wuling")
	local wind = ( JinXuanDi and JinXuanDi:getMark("@wind") > 0 )
	local thunder = ( JinXuanDi and JinXuanDi:getMark("@thunder") > 0 )
	local function getValue(target)
		local v = 0
		local chouhai_flag = ( target:hasSkill("chouhai") and target:isKongcheng() )
		local silver_lion = target:hasArmorEffect("silver_lion")
		local total = 0
		if self:damageIsEffective(target, sgs.DamageStruct_Thunder, self.player) then
			local count = 1
			if chouhai_flag then
				count = count + 1
			end
			if thunder then
				count = count + 1
			end
			if silver_lion and count > 1 then
				count = 1
			end
			v = v + count * 2
			total = total + count
		end
		if self:damageIsEffective(target, sgs.DamageStruct_Fire, self.player) then
			local count = 1
			if chouhai_flag then
				count = count + 1
			end
			if wind then
				count = count + 1
			end
			if silver_lion and count > 1 then
				count = 1
			end
			v = v + count * 2
			total = total + count
		end
		if self:damageIsEffective(target, sgs.DamageStruct_Normal, self.player) then
			local count = 1
			if chouhai_flag then
				count = count + 1
			end
			if silver_lion and count > 1 then
				count = 1
			end
			v = v + count * 2
			total = total + count
		end
		if total >= target:getHp() and self:getAllPeachNum(target) == 0 then
			v = v + 100
		end
		if self:isFriend(target) then
			v = - v
		end
		return v
	end
	local players = {}
	for _,p in sgs.qlist(targets) do
		table.insert(players, p)
		values[p:objectName()] = getValue(p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local target = players[1]
	local value = values[target:objectName()] or 0
	if value > 0 then
		return target
	end
end
--room:askForCardChosen(player, p, "h", "crNuMa_Case23")
--room:askForPlayerChosen(player, targets, "crNuMa_Case24", "@crNuMa_Case24", true)
sgs.ai_skill_playerchosen["crNuMa_Case24"] = function(self, targets)
	local enemies = {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			table.insert(enemies, p)
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		return enemies[1]
	end
end
--room:askForPlayerChosen(player, targets, "crNuMa_Case25", "@crNuMa_Case25", true)
sgs.ai_skill_playerchosen["crNuMa_Case25"] = function(self, targets)
	local friends, enemies = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	local bad_skills = "benghuai|wumou|shiyong|yaowu|chanyuan|zaoyao|chouhai"
	if #friends > 0 then
		self:sort(friends, "defense")
		for _,friend in ipairs(friends) do
			if self:hasSkills(bad_skills, friend) then
				return friend
			end
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		for _,enemy in ipairs(enemies) do
			if enemy:hasSkills("benghuai+wumou+shiyong+yaowu+chanyuan+zaoyao+chouhai") then
			elseif self:hasSkills("yinghun|miji|nosmiji|nosshangshi|chizhong", enemy) then
			else
				return enemy
			end
		end
	end
end
--room:askForChoice(player, "crNuMa_Case25", choices, ai_data)
sgs.ai_skill_choice["crNuMa_Case25"] = function(self, choices, data)
	local target = data:toPlayer()
	local skills = choices:split("+")
	if self:isFriend(target) then
		for _,skill in ipairs(skills) do
			if target:hasSkill(skill) then
				return skill
			end
		end
	else
		for _,skill in ipairs(skills) do
			if not target:hasSkill(skill) then
				return skill
			end
		end
	end
end
--[[
	技能：桀骜（锁定技）
	描述：回合开始阶段，若你的手牌数小于当前体力值，你摸2张牌。
]]--
--[[
	技能：反唇
	描述：你可以把对你造成伤害的牌加入语录表。
]]--
--room:askForSkillInvoke(player, "crFanChun", data)
sgs.ai_skill_invoke["crFanChun"] = true
--Case01：回复一点体力
sgs.yulu_info[1] = {
	code = "hc",
	command = "heart+club",
	total = 2,
	heart = 1,
	club = 1,
	benefit = true,
}
sgs.yulu_value[1] = function(self, isWeak)
	local v = 0
	local x = self.player:getLostHp()
	if x > 0 then
		v = v + 20
		if self.player:getHp() >= getBestHp(self.player) then
			v = v - 5
		end
		if self:hasSkills(sgs.masochism_skill) then
			v = v + 3
		end
		if self.player:hasSkill("shushen") then
			v = v + 2
		end
		if isWeak then
			v = v + 10
		end
	end
	return 0
end
--Case02：令一名角色弃两张牌
sgs.yulu_info[2] = {
	code = "dc",
	command = "diamond+club",
	total = 2,
	club = 1,
	diamond = 1,
	benefit = true,
	value = function(self, target)
		local count = target:getCardCount(true)
		return math.min(2, count)
	end,
}
sgs.yulu_value[2] = function(self, isWeak)
	local max_v = 0
	for _,enemy in ipairs(self.enemies) do
		local count = enemy:getCardCount(true)
		local v = 0
		if count == 0 then
			continue
		elseif count == 1 then
			v = v + 10
		elseif count >= 2 then
			v = v + 20
		end
		if enemy:hasEquip() then
			if self:hasSkills(sgs.lose_equip_skill, enemy) then
				v = v - 15
			end
			if enemy:getArmor() and self:needToThrowArmor(enemy) then
				v = v - 20
			end
			if enemy:getHandcardNum() == 1 and self:needKongcheng(enemy) then
				v = v - 7
			end
		end
		if enemy:hasSkill("tuntian") then
			v = v - 8
		end
		if enemy:hasSkill("lirang") and #self.enemies > 1 then
			v = v - 3
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case03：清空一名角色的判定区
sgs.yulu_info[3] = {
	code = "cc",
	command = "club+club",
	total = 2,
	club = 2,
	benefit = true,
}
sgs.yulu_value[3] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends) do
		if not friend:containsTrick("YanxiaoCard") then
			local v = 0
			if friend:containsTrick("indulgence") then
				v = v + 8
				local overflow = self:getOverflow(friend)
				if overflow >= 0 then
					v = v + overflow * 0.5
				end
			end
			if friend:containsTrick("supply_shortage") then
				v = v + 7
				if friend:hasSkill("tiandu") then
					v = v - 1
				end
				if self:hasSkills(sgs.cardneed_skill, friend) then
					v = v + 10
				end
			end
			if friend:containsTrick("lightning") then
				if self:getFinalRetrial(friend, "lightning") == 2 then
					v = v + 60
				end
			end
			if v > max_v then
				max_v = v
			end
		end
	end
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		if enemy:containsTrick("YanxiaoCard") then
			v = v + enemy:getJudgingArea():length() * 1.2
		elseif enemy:containsTrick("lightning") then
			if self:getFinalRetrial(enemy, "lightning") == 2 then
				v = v + 60
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case04：展示并获得一名角色的一张手牌，令其回复一点体力
sgs.yulu_info[4] = {
	code = "sd",
	command = "spade+diamond",
	total = 2,
	spade = 1,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[4] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends_noself) do
		if friend:getLostHp() > 0 and not friend:isKongcheng() then
			local v = 20
			if self:hasSkills(sgs.masochism_skill, friend) then
				v = v + 3
			end
			if friend:getHandcardNum() == 1 and self:needKongcheng(friend) then
				v = v + 2
			elseif self:hasSkills(sgs.cardneed_skill, friend) then
				v = v - 5
			end
			if friend:getHp() >= getBestHp(friend) then
				v = v - 4
			end
			if v > max_v then
				max_v = v
			end
		end
	end
	return max_v
end
--Case05：进行一次判定，若结果为桃或桃园结义，获得技能“反唇”
sgs.yulu_info[5] = {
	code = "hs",
	command = "heart+spade",
	total = 2,
	spade = 1,
	heart = 1,
	benefit = true,
}
sgs.yulu_value[5] = function(self, isWeak)
	if self.player:hasSkill("crFanChun") then
		return 0
	end
	if self:hasSkills(sgs.wizard_skill) then
		return 5
	end
	return 2
end
--Case06：与一名受伤的女性角色各回复一点体力
sgs.yulu_info[6] = {
	code = "hsc",
	command = "heart+spade+club",
	total = 3,
	spade = 1,
	heart = 1,
	club = 1,
	benefit = true,
}
sgs.yulu_value[6] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends_noself) do
		if friend:isFemale() and friend:isWounded() then
			local v = 0
			if friend:getLostHp() > 0 then
				v = v + 20
				if self:hasSkills(sgs.masochism_skill, friend) then
					v = v + 3
				end
				if friend:hasSkill("shushen") then
					v = v + 2
				end
				if friend:getHp() >= getBestHp(friend) then
					v = v - 5
				end
			end
			if v > max_v then
				max_v = v
			end
		end
	end
	if self.player:getLostHp() > 0 then
		max_v = max_v + 20
		if isWeak then
			max_v = max_v + 10
		end
		if self:hasSkills(sgs.masochism_skill) then
			max_v = max_v + 3
		end
		if self.player:hasSkill("shushen") then
			max_v = max_v + 2
		end
	end
	return max_v
end
--Case07：与一名受伤的男性角色各回复一点体力
sgs.yulu_info[7] = {
	code = "hsd",
	command = "heart+spade+diamond",
	total = 3,
	spade = 1,
	heart = 1,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[7] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends_noself) do
		if friend:isMale() and friend:isWounded() then
			local v = 0
			if friend:getLostHp() > 0 then
				v = v + 20
				if self:hasSkills(sgs.masochism_skill, friend) then
					v = v + 3
				end
				if friend:hasSkill("shushen") then
					v = v + 2
				end
				if friend:getHp() >= getBestHp(friend) then
					v = v - 5
				end
			end
			if v > max_v then
				max_v = v
			end
		end
	end
	if self.player:getLostHp() > 0 then
		max_v = max_v + 20
		if isWeak then
			max_v = max_v + 10
		end
		if self:hasSkills(sgs.masochism_skill) then
			max_v = max_v + 3
		end
		if self.player:hasSkill("shushen") then
			max_v = max_v + 2
		end
	end
	return max_v
end
--Case08：令一名其他角色杀自己，否则获得其所有牌
sgs.yulu_info[8] = {
	code = "dsh",
	command = "diamond+spade+heart",
	total = 3,
	spade = 1,
	heart = 1,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[8] = function(self, isWeak)
	local max_v = 0
	local jinkNum = self:getCardsNum("Jink")
	local overflow = self:getOverflow()
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		local count = enemy:getCardCount(true)
		local no_slash = false
		if sgs.card_lack[enemy:objectName()]["Slash"] == 1 then
			no_slash = true
			v = v + count * 10
		elseif getCardsNum("Slash", enemy, self.player) == 0 then
			no_slash = true
			v = v + count * 8
		end
		local damage = true
		if no_slash then
			damage = false
			if enemy:hasEquip() then
				if self:hasSkills(sgs.lose_equip_skill, enemy) then
					v = v - 20
				end
				if enemy:getArmor() and self:needToThrowArmor(enemy) then
					v = v - 20
				end
			end
			if enemy:getHandcardNum() == 1 and self:needKongcheng(enemy) then
				v = v - 6
			end
		else
			if enemy:hasWeapon("double_sword") and self.player:getGender() ~= enemy:getGender() then
				v = v - 10
			end
			if self:canHit(self.player, enemy) then
				damage = true
			elseif jinkNum > 0 then
				damage = false
			end
		end
		if damage then
			if self:getDamagedEffects(self.player, enemy, true) then
				v = v + 20
			end
			if self:needToLoseHp(self.player, enemy, true) then
				v = v + 6
			end
		else
			if overflow > 0 and jinkNum > 1 then
				v = v + 7
			end
			if self:needLeiji(self.player, enemy) then
				v = v + 40
			end
		end
		if enemy:hasSkill("tuntian") then
			v = v - 5
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case09：令一名角色对自己造成一点伤害，然后其回复一点体力
sgs.yulu_info[9] = {
	code = "shc",
	command = "spade+heart+club",
	total = 3,
	spade = 1,
	heart = 1,
	club = 1,
	benefit = true,
}
sgs.yulu_value[9] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends) do
		local v = 0
		if self:damageIsEffective(self.player, sgs.DamageStruct_Normal, friend) then
			v = v - 20
			if self.player:getHp() > getBestHp(self.player) then
				v = v + 10
			end
			if self:needToLoseHp() then
				v = v + 8
			end
			if isWeak then
				v = v - 15
			end
		end
		if friend:getLostHp() > 0 then
			v = v + 20
			if self:isWeak(friend) then
				v = v + 12
				if friend:isLord() then
					v = v + 5
				end
			end
			if self:hasSkills(sgs.masochism_skill, friend) then
				v = v + 3
			end
			if friend:hasSkill("shushen") then
				v = v + 2
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case10：自己翻面并摸三张牌
sgs.yulu_info[10] = {
	code = "hhh",
	command = "heart+heart+heart",
	total = 3,
	heart = 3,
	benefit = true,
}
sgs.yulu_value[10] = function(self, isWeak)
	local v = 30
	local ChenQun = self.room:findPlayerBySkillName("faen")
	local flag = ( ChenQun and self:isFriend(ChenQun) or false )
	if self:toTurnOver(self.player, 3, "crNuMa") then
		v = v - 25
	else
		v = v + 25
	end
	if flag then
		v = v + 10
	end
	return v
end
--Case11：令一名角色翻面并摸X张牌，其中X为自己已损失的体力
sgs.yulu_info[11] = {
	code = "sss",
	command = "spade+spade+spade",
	total = 3,
	spade = 3,
	benefit = true,
}
sgs.yulu_value[11] = function(self, isWeak)
	local max_v = 0
	local x = self.player:getLostHp()
	local ChenQun = self.room:findPlayerBySkillName("faen")
	local flag = ( ChenQun and self:isFriend(ChenQun) or false )
	for _,friend in ipairs(self.friends) do
		local v = 0
		if friend:hasSkill("manjuan") and friend:objectName() ~= self.player:objectName() then
		else
			v = v + x * 10
		end
		if friend:faceUp() then
			v = v - 25
		else
			v = v + 25
		end
		if friend:hasSkill("jiewei") then
			v = v + 5
		end
		if flag then
			v = v + 10
		end
		if v > max_v then
			max_v = v
		end
	end
	flag = ( ChenQun and self:isEnemy(ChenQun) or false )
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		if not enemy:hasSkill("manjuan") then
			v = v - x * 10
		end
		if enemy:faceUp() then
			v = v + 25
		else
			v = v - 25
		end
		if enemy:hasSkill("jiewei") then
			v = v - 5
		end
		if flag then
			v = v - 10
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case12：令一名角色获得语录表中所有牌
sgs.yulu_info[12] = {
	code = "ddd",
	command = "diamond+diamond+diamond",
	total = 3,
	diamond = 3,
	benefit = true,
}
sgs.yulu_value[12] = function(self, isWeak)
	if #self.friends_noself > 0 then
		for _,friend in ipairs(self.friends_noself) do
			if not friend:hasSkill("manjuan") then
				return 30
			end
		end
	end
	return 0
end
--Case13：清空一名角色的装备区
sgs.yulu_info[13] = {
	code = "ccc",
	command = "club+club+club",
	total = 3,
	club = 3,
	benefit = true,
}
sgs.yulu_value[13] = function(self, isWeak)
	local max_v = 0
	for _,friend in ipairs(self.friends) do
		local v = 0
		local count = friend:getEquips():length()
		if count > 0 then
			v = v - count * 10
			if friend:getArmor() and self:needToThrowArmor(friend) then
				v = v + 20
			end
			if self:hasSkills(sgs.lose_equip_skill, friend) then
				v = v + 10
			end
			if friend:hasSkill("tuntian") and friend:objectName() ~= self.player:objectName() then
				v = v + 4
			end
			if friend:getArmor() then
				v = v - 5
				if self:isWeak(friend) then
					v = v - 3
				end
			end
			if friend:getDefensiveHorse() then
				v = v - 4
			end
			if friend:getWeapon() then
				v = v - 3
			end
			if friend:getTreasure() then
				v = v - 2
			end
			if friend:getOffensiveHorse() then
				v = v - 1
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		local count = enemy:getEquips():length()
		if count > 0 then
			v = v + count * 10
			if enemy:getArmor() and self:needToThrowArmor(enemy) then
				v = v - 20
			end
			if self:hasSkills(sgs.lose_equip_skill, enemy) then
				v = v - 10
			end
			if enemy:hasSkill("tuntian") then
				v = v - 4
			end
			if enemy:getArmor() then
				v = v + 5
				if self:isWeak(enemy) then
					v = v + 3
				end
			end
			if enemy:getDefensiveHorse() then
				v = v + 4
			end
			if enemy:getWeapon() then
				v = v + 3
			end
			if enemy:getTreasure() then
				v = v + 2
			end
			if enemy:getOffensiveHorse() then
				v = v + 1
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	return max_v
end
--Case14：清空语录表并指定一名角色获得一个额外的回合
sgs.yulu_info[14] = {
	code = "dcdc",
	command = "diamond+club+diamond+club",
	total = 4,
	club = 2,
	diamond = 2,
	benefit = true,
}
sgs.yulu_value[14] = function(self, isWeak)
	return 25
end
--Case15：视为对一名角色使用了一张杀，属性待定
sgs.yulu_info[15] = {
	code = "sdc",
	command = "spade+diamond+club",
	total = 3,
	spade = 1,
	club = 1,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[15] = function(self, isWeak)
	local dummy_use = {
		isDummy = true,
		to = sgs.SPlayerList(),
	}
	local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
	slash:deleteLater()
	self:useBasicCard(slash, dummy_use)
	if dummy_use.card and not dummy_use.to:isEmpty() then
		local target = dummy_use.to:first()
		local v = 0
		local damage = false
		if self:canHit(target, self.player) then
			damage = true
		else
			local jinkNum = getCardsNum("Jink", target, self.player)
			local needJinkNum = 1
			if self.player:hasSkill("wushuang") then
				needJinkNum = needJinkNum + 1
			end
			if target:isFemale() and self.player:hasSkill("roulin") then
				needJinkNum = needJinkNum + 1
			end
			if jinkNum < needJinkNum then
				damage = true
			else
				v = v + needJinkNum * 10
			end
			local times = math.min(jinkNum, needJinkNum)
			if target:hasSkill("leiji") or target:hasSkill("nosleiji") then
				v = v - times * 20
			end
		end
		if damage then
			damage = self:hasHeavySlashDamage(self.player, slash, target, true)
			v = v + damage * 20
			if target:getHp() + self:getAllPeachNum(target) <= damage then
				v = v + 100
			end
		end
		if self:isFriend(target) then
			v = - v
		end
		return v
	end
	return 0
end
--Case16：视为对一名角色使用了一张酒杀
sgs.yulu_info[16] = {
	code = "hsdc",
	command = "heart+spade+diamond+club",
	total = 4,
	spade = 1,
	heart = 1,
	club = 1,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[16] = function(self, isWeak)
	local dummy_use = {
		isDummy = true,
		to = sgs.SPlayerList(),
	}
	local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
	slash:deleteLater()
	self:useBasicCard(slash, dummy_use)
	if dummy_use.card and not dummy_use.to:isEmpty() then
		local target = dummy_use.to:first()
		local v = 0
		local damage = false
		if self:canHit(target, self.player) then
			damage = true
		else
			local jinkNum = getCardsNum("Jink", target, self.player)
			local needJinkNum = 1
			if self.player:hasSkill("wushuang") then
				needJinkNum = needJinkNum + 1
			end
			if target:isFemale() and self.player:hasSkill("roulin") then
				needJinkNum = needJinkNum + 1
			end
			if jinkNum < needJinkNum then
				damage = true
			else
				v = v + needJinkNum * 10
			end
			local times = math.min(jinkNum, needJinkNum)
			if target:hasSkill("leiji") or target:hasSkill("nosleiji") then
				v = v - times * 20
			end
		end
		if damage then
			damage = self:hasHeavySlashDamage(self.player, slash, target, true)
			if not target:hasArmorEffect("silver_lion") then
				if not self.player:hasSkill("jueqing") then
					damage = damage + 1
				end
			end
			v = v + damage * 20
			if target:getHp() + self:getAllPeachNum(target) <= damage then
				v = v + 100
			end
		end
		if self:isFriend(target) then
			v = - v
		end
		return v
	end
	return 0
end
--Case17：回复所有体力
sgs.yulu_info[17] = {
	code = "ccsh",
	command = "club+club+spade+heart",
	total = 4,
	spade = 1,
	heart = 1,
	club = 2,
	benefit = true,
}
sgs.yulu_value[17] = function(self, isWeak)
	local v = 0
	local lost = self.player:getLostHp()
	if lost > 0 then
		v = v + lost * 20
		if self.player:hasSkill("shushen") then
			v = v + 2
		end
		if self:hasSkills(sgs.masochism_skill) then
			v = v + 3
		end
		if isWeak then
			v = v + 10
		end
		if self.player:getHp() >= getBestHp(self.player) then
			v = v - 8
		end
	end
	return v
end
--Case18：令一名角色观看另一名角色的所有手牌
sgs.yulu_info[18] = {
	code = "dsdc",
	command = "diamond+spade+diamond+club",
	total = 4,
	spade = 1,
	club = 1,
	diamond = 2,
	benefit = true,
}
sgs.yulu_value[18] = function(self, isWeak)
	for _,enemy in ipairs(self.enemies) do
		if not enemy:isKongcheng() then
			return 3
		end
	end
	return 0
end
--Case19：自杀
sgs.yulu_info[19] = {
	code = "dshc",
	command = "diamond+spade+heart+club",
	total = 4,
	spade = 1,
	heart = 1,
	club = 1,
	diamond = 1,
	benefit = false,
}
sgs.yulu_value[19] = function(self, isWeak)
	return -9999
end
--Case20：自己变身为邓艾
sgs.yulu_info[20] = {
	code = "hhhhh",
	command = "heart+heart+heart+heart+heart",
	total = 5,
	heart = 5,
	benefit = false,
}
sgs.yulu_value[20] = function(self, isWeak)
	if self:hasSkills("tuntian|zaoxian|jixi", self.player) then
		return -10
	end
	return 0
end
--Case21：弃置一名角色四张牌，然后对自己造成2点伤害
sgs.yulu_info[21] = {
	code = "dshcc",
	command = "diamond+spade+heart+club+club",
	total = 5,
	spade = 1,
	heart = 1,
	club = 2,
	diamond = 1,
	benefit = true,
}
sgs.yulu_value[21] = function(self, isWeak)
	local max_v = 0
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		local count = enemy:getCardCount(true)
		if count > 0 then
			count = math.min(4, count)
			v = v + count * 10
			if enemy:hasSkill("tuntian") then
				v = v - 3
			end
			if enemy:hasSkill("lirang") and #self.enemies > 1 then
				v = v - 5
			end
			if enemy:hasEquip() then
				if enemy:isKongcheng() then
					if count == 1 and enemy:getArmor() and self:needToThrowArmor(enemy) then
						v = v - 20
					end
				end
				if enemy:getHandcardNum() < count then
					if self:hasSkills(sgs.lose_equip_skill, enemy) then
						v = v - 20
					end
				end
				local dangerous = self:getDangerousCard(enemy)
				if dangerous and dangerous:isEquipped() then
					v = v + 7
				end
				if enemy:getArmor() then
					v = v + 4
				end
				if enemy:getDefensiveHorse() then
					v = v + 3
				end
			else
				if enemy:getHandcardNum() < count and self:needKongcheng(enemy) then
					v = v - 8
				end
			end
			if count < 4 then
				v = v + 6
				if self:isWeak(enemy) then
					v = v + 5
				end
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	if self:damageIsEffective(self.player, sgs.DamageStruct_Normal, self.player) then
		if self.player:hasArmorEffect("silver_lion") then
			max_v = max_v - 20
		else
			max_v = max_v - 40
		end
		if isWeak then
			max_v = max_v - 10
		end
		if self.player:getHp() + self:getAllPeachNum() <= 2 then
			max_v = max_v - 100
		else
			if self:hasSkills(sgs.masochism_skill) then
				max_v = max_v + 7
			end
			if getBestHp(self.player) - 2 >= self.player:getHp() then
				max_v = max_v + 5
			end
		end
	end
	return max_v
end
--Case22：限定技，对一名角色造成一点雷电伤害、一点火焰伤害、一点普通伤害，然后自己失去2点体力
sgs.yulu_info[22] = {
	code = "hsdcc",
	command = "heart+spade+diamond+club+club",
	total = 5,
	spade = 1,
	heart = 1,
	club = 2,
	diamond = 1,
	benefit = true,
	mark = "crNuMa_hsdcc",
}
sgs.yulu_value[22] = function(self, isWeak)
	local max_v = 0
	local JinXuanDi = self.room:findPlayerBySkillName("wuling")
	local wind = ( JinXuanDi and JinXuanDi:getMark("@wind") > 0 )
	local thunder = ( JinXuanDi and JinXuanDi:getMark("@thunder") > 0 )
	for _,enemy in ipairs(self.enemies) do
		local v = 0
		local total = 0
		local chouhai = ( enemy:isKongcheng() and enemy:hasSkill("chouhai") )
		local lion = enemy:hasArmorEffect("silver_lion")
		if self:damageIsEffective(enemy, sgs.DamageStruct_Thunder, self.player) then
			local damage = 1
			if thunder then
				damage = damage + 1
			end
			if chouhai then
				damage = damage + 1
			end
			if lion and damage > 1 then
				damage = 1
			end
			total = total + damage
		end
		if self:damageIsEffective(enemy, sgs.DamageStruct_Fire, self.player) then
			local damage = 1
			if wind then
				damage = damage + 1
			end
			if enemy:hasArmorEffect("gale_shell") then
				damage = damage + 1
			end
			if enemy:getMark("@gale") > 0 then
				damage = damage + 1
			end
			if chouhai then
				damage = damage + 1
			end
			if lion and damage > 1 then
				damage = 1
			end
			total = total + damage
		end
		if self:damageIsEffective(enemy, sgs.DamageStruct_Normal, self.player) then
			local damage = 1
			if chouhai then
				damage = damage + 1
			end
			if lion and damage > 1 then
				damage = 1
			end
			total = total + damage
		end
		v = v + total * 20
		if total >= enemy:getHp() + self:getAllPeachNum(enemy) then
			max_v = max_v + 80
		else
			if self.player:hasSkill("jueqing") then
			elseif self:hasSkills(sgs.masochism_skill, enemy) then
				v = v - 15
			end
			if enemy:getHp() - total >= getBestHp(enemy) then
				v = v - 3
			end
		end
		if v > max_v then
			max_v = v
		end
	end
	max_v = max_v - 20
	if self.player:getHp() + self:getAllPeachNum() <= 2 then
		max_v = max_v - 100
	end
	return max_v
end
--Case23：限定技，获得所有角色各一张手牌，然后将自己武将牌翻面
sgs.yulu_info[23] = {
	code = "dcshc",
	command = "diamond+club+spade+heart+club",
	total = 5,
	spade = 1,
	heart = 1,
	club = 2,
	diamond = 1,
	benefit = true,
	mark = "crNuMa_dcshc",
}
sgs.yulu_value[23] = function(self, isWeak)
	local value = 0
	local others = self.room:getOtherPlayers()
	for _,p in sgs.qlist(others) do
		if not p:isKongcheng() then
			local v = 10
			if p:getHandcardNum() == 1 and self:needKongcheng(p) then
				v = v - 2
			end
			if p:hasSkill("tuntian") then
				v = v - 2
			end
			if self:isFriend(p) then
				v = - v
			end
			value = value + v
		end
	end
	if self.player:faceUp() then
		value = value - 25
	else
		value = value + 25
	end
	local ChenQun = self.room:findPlayerBySkillName("faen")
	if ChenQun and self:isFriend(ChenQun) then
		value = value + 10
	end
	return value
end
--Case24：限定技，立即引爆场上的一张闪电
sgs.yulu_info[24] = {
	code = "ssdcc",
	command = "spade+spade+diamond+club+club",
	total = 5,
	spade = 2,
	club = 2,
	diamond = 1,
	benefit = true,
	mark = "crNuMa_ssdcc",
}
sgs.yulu_value[24] = function(self, isWeak)
	for _,enemy in ipairs(self.enemies) do
		if enemy:containsTrick("lightning") then
			if enemy:getMark("@fenyong") == 0 then
				return 60
			end
		end
	end
	return 0
end
--Case25：限定技，令一名体力上限比你多的角色增加一点体力上限，获得一个负面技能
sgs.yulu_info[25] = {
	code = "ssscc",
	command = "spade+spade+spade+club+club",
	total = 5,
	spade = 3,
	club = 2,
	benefit = true,
	mark = "crNuMa_ssscc",
}
sgs.yulu_value[25] = function(self, isWeak)
	local bad_skills = "benghuai|wumou|shiyong|yaowu|zaoyao|chanyuan|chouhai"
	for _,friend in ipairs(sgs.friends_noself) do
		if self:hasSkills(bad_skills, friend) then
			return 25
		end
	end
	for _,enemy in ipairs(sgs.enemies) do
		if not self:hasSkills(bad_skills, enemy) then
			return 10
		end
	end
	return 0
end
--Case26：变为素将，然后增加2点体力上限
sgs.yulu_info[26] = {
	total = 4,
	benefit = false,
}
sgs.yulu_value[26] = function(self, isWeak)
	if isWeak then
		return 0
	end
	return -10
end
--Case27：限定技，失去一点体力上限，获得技能“龙魂”
sgs.yulu_info[27] = {
	total = 5,
	benefit = true,
	mark = "crNuMa_five_words",
}
sgs.yulu_value[27] = function(self, isWeak)
	if self.player:getMaxHp() == 1 then
		return -9999
	end
	if self.player:hasSkill("longhun") then
		return -20
	end
	if isWeak and self.player:getCardCount(true) > 0 then
		return 5
	end
	return 1
end
--Case28：限定技，失去2点体力上限，获得技能“无言”、“不屈”
sgs.yulu_info[28] = {
	benefit = true,
	mark = "crNuMa_other_words",
}
sgs.yulu_value[28] = function(self, isWeak)
	if self.player:getMaxHp() <= 2 then
		return -9999
	end
	if self:hasSkills("wuyan|buqu") then
		return -40
	end
	if isWeak then
		return 1
	end
	return 0
end
--Case29：无效果
--[[****************************************************************
	编号：CCC - 05
	武将：十胜郭嘉
	称号：天妒英才
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
--[[
	技能：十胜
	描述：游戏开始时，你获得一枚“致胜”标记。每当你受到或造成一次伤害，你获得一枚“致胜”标记（最多十枚）。出牌阶段，若你有：
		1枚“致胜”标记，你可以将一张点数为5的手牌当做任意一张基本牌或锦囊牌使用；
		2枚“致胜”标记，你可以将一张点数为10的手牌当做任意一张基本牌或锦囊牌使用；
		3枚“致胜”标记，你可以弃一枚“致胜”标记，将两张花色、点数均相同的手牌当做任意一张基本牌或锦囊牌使用；
		4枚“致胜”标记，你可以弃一枚“致胜”标记，将两张同点数的手牌当做任意一张基本牌或锦囊牌使用；
		5枚“致胜”标记，你可以弃一枚“致胜”标记，将两张同花色的手牌当做任意一张基本牌或锦囊牌使用；
		6枚“致胜”标记，你可以弃一枚“致胜”标记，将三张手牌当做任意一张基本牌或锦囊牌使用；
		7枚“致胜”标记，你可以弃两枚“致胜”标记，将一张锦囊牌当做任意一张基本牌或锦囊牌使用；
		8枚“致胜”标记，你可以弃两枚“致胜”标记，将一张装备牌当做任意一张基本牌或锦囊牌使用；
		9枚“致胜”标记，你可以弃两枚“致胜”标记，将一张基本牌当做任意一张基本牌或锦囊牌使用；
		10枚“致胜”标记，你可以弃三枚“致胜”标记，将一张牌当做任意一张基本牌或锦囊牌使用。 
]]--
--room:askForChoice(source, "crShiShengType", items, sgs.QVariant(true))
--room:askForChoice(source, "crShiShengType", choices)
sgs.ai_skill_choice["crShiShengType"] = function(self, choices, data)
	local multi_page = data:toBool()
	local items = ""
	if multi_page then
		items = self.player:getTag("crShiShengAIData"):toString() or ""
	else
		items = choices
	end
	items = items:split("+")
	while #items > 0 do
		local index = math.random(1, #items)
		local name = items[index]
		local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
		if card then
			card:deleteLater()
			local dummy_use = {
				isDummy = true,
			}
			if card:isKindOf("BasicCard") then
				self:useBasicCard(card, dummy_use)
			elseif card:isKindOf("TrickCard") then
				self:useTrickCard(card, dummy_use)
			end
			if dummy_use.card then
				return name
			end
		end
		table.remove(items, index)
	end
end
--room:askForUseCard(source, "@@crShiShengSelect", prompt)
sgs.ai_skill_use["@@crShiShengSelect"] = function(self, prompt, method)
	local name = self.player:property("crShiShengType"):toString() or ""
	local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
	card:deleteLater()
	local dummy_use = {
		isDummy = true,
		to = sgs.SPlayerList(),
	}
	if card:isKindOf("BasicCard") then
		self:useBasicCard(card, dummy_use)
	elseif card:isKindOf("TrickCard") then
		self:useTrickCard(card, dummy_use)
	end
	if dummy_use.card then
		local targets = {}
		for _,p in sgs.qlist(dummy_use.to) do
			table.insert(targets, p:objectName())
		end
		if #targets > 0 then
			return "#crShiShengSelectCard:.:->"..table.concat(targets, "+")
		end
	end
	self.room:setPlayerFlag(self.player, "AI_crShiShengFailed")
	return "."
end
--room:askForChoice(source, "crShiSheng", choices)
sgs.ai_skill_choice["crShiSheng"] = function(self, choices, data)
	local mark = self.player:getMark("@crShiShengMark")
	mark = math.min(10, mark)
	local handcards = self.player:getHandcards()
	local num = handcards:length()
	if num > 0 then
		if mark >= 1 then
			for _,card in sgs.qlist(handcards) do
				if card:getNumber() == 5 then
					return "Case1"
				end
			end
		end
		if mark >= 2 then
			for _,card in sgs.qlist(handcards) do
				if card:getNumber() == 10 then
					return "Case2"
				end
			end
		end
	end
	local cards = self.player:getCards("he")
	local num2 = cards:length()
	if num2 > 0 then
		if mark >= 7 then
			for _,card in sgs.qlist(cards) do
				if card:isKindOf("TrickCard") == 5 then
					return "Case7"
				end
			end
		end
		if mark >= 8 then
			for _,card in sgs.qlist(cards) do
				if card:isKindOf("EquipCard") == 5 then
					return "Case8"
				end
			end
		end
		if mark >= 9 then
			for _,card in sgs.qlist(cards) do
				if card:isKindOf("BasicCard") == 5 then
					return "Case9"
				end
			end
		end
		if mark == 10 then
			return "Case10"
		end
	end
	if num > 1 then
		local same_suit = false
		if mark >= 3 then
			for _,cardA in sgs.qlist(handcards) do
				local suit = cardA:getSuit()
				local point = cardA:getNumber()
				for _,cardB in sgs.qlist(handcards) do
					if cardB:getSuit() == suit then
						same_suit = true
						if cardB:getNumber() == point then
							return "Case3"
						end
					end
				end
			end
		end
		if mark >= 4 then
			for _,cardA in sgs.qlist(handcards) do
				local point = cardA:getNumber()
				for _,cardB in sgs.qlist(handcards) do
					if cardB:getNumber() == point then
						return "Case4"
					end
				end
			end
		end
		if mark >= 5 then
			if same_suit then
				return "Case5"
			end
			for _,cardA in sgs.qlist(handcards) do
				local suit = cardA:getSuit()
				for _,cardB in sgs.qlist(handcards) do
					if cardB:getSuit() == suit then
						return "Case5"
					end
				end
			end
		end
	end
	if mark >= 6 and num > 2 then
		return "Case6"
	end
	self.room:setPlayerFlag(self.player, "AI_crShiShengFailed")
	return "cancel"
end
--room:askForUseCard(source, "@@crShiSheng", prompt)
sgs.ai_skill_use["@@crShiSheng"] = function(self, prompt, method)
	local case = self.player:getMark("crShiShengCase")
	local flag = ( case < 7 ) and "h" or "he"
	local cards = self.player:getCards(flag)
	local to_use = {}
	if case == 1 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			if c:getNumber() == 5 then
				table.insert(can_use, c)
			end
		end
		if #can_use > 0 then
			self:sortByUseValue(can_use, true)
			table.insert(to_use, can_use[1]:getEffectiveId())
		end
	elseif case == 2 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			if c:getNumber() == 10 then
				table.insert(can_use, c)
			end
		end
		if #can_use > 0 then
			self:sortByUseValue(can_use, true)
			table.insert(to_use, can_use[1]:getEffectiveId())
		end
	elseif case == 3 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			local dummy_use = {
				isDummy = true,
			}
			if c:isKindOf("BasicCard") then
				self:useBasicCard(c, dummy_use)
			elseif c:isKindOf("EquipCard") then
				self:useEquipCard(c, dummy_use)
			elseif c:isKindOf("TrickCard") then
				self:useTrickCard(c, dummy_use)
			end
			if not dummy_use.c then
				table.insert(can_use, c)
			end
		end
		self:sortByUseValue(can_use, true)
		if #can_use >= 2 then
			for _,cardA in ipairs(can_use) do
				local suit = cardA:getSuit()
				local point = cardA:getNumber()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if suit == cardB:getSuit() and point == cardB:getNumber() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
		if #to_use == 0 and math.random(1, 100) <= 70 then
			can_use = sgs.QList2Table(cards) 
			self:sortByUseValue(can_use, true)
			for _,cardA in ipairs(can_use) do
				local suit = cardA:getSuit()
				local point = cardA:getNumber()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if suit == cardB:getSuit() and point == cardB:getNumber() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
	elseif case == 4 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			local dummy_use = {
				isDummy = true,
			}
			if c:isKindOf("BasicCard") then
				self:useBasicCard(c, dummy_use)
			elseif c:isKindOf("EquipCard") then
				self:useEquipCard(c, dummy_use)
			elseif c:isKindOf("TrickCard") then
				self:useTrickCard(c, dummy_use)
			end
			if not dummy_use.c then
				table.insert(can_use, c)
			end
		end
		self:sortByUseValue(can_use, true)
		if #can_use >= 2 then
			for _,cardA in ipairs(can_use) do
				local point = cardA:getNumber()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if point == cardB:getNumber() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
		if #to_use == 0 and math.random(1, 100) <= 70 then
			can_use = sgs.QList2Table(cards) 
			self:sortByUseValue(can_use, true)
			for _,cardA in ipairs(can_use) do
				local point = cardA:getNumber()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if point == cardB:getNumber() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
	elseif case == 5 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			local dummy_use = {
				isDummy = true,
			}
			if c:isKindOf("BasicCard") then
				self:useBasicCard(c, dummy_use)
			elseif c:isKindOf("EquipCard") then
				self:useEquipCard(c, dummy_use)
			elseif c:isKindOf("TrickCard") then
				self:useTrickCard(c, dummy_use)
			end
			if not dummy_use.c then
				table.insert(can_use, c)
			end
		end
		self:sortByUseValue(can_use, true)
		if #can_use >= 2 then
			for _,cardA in ipairs(can_use) do
				local suit = cardA:getSuit()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if suit == cardB:getSuit() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
		if #to_use == 0 and math.random(1, 100) <= 70 then
			can_use = sgs.QList2Table(cards) 
			self:sortByUseValue(can_use, true)
			for _,cardA in ipairs(can_use) do
				local suit = cardA:getSuit()
				for _,cardB in ipairs(can_use) do
					if cardA:getEffectiveId() ~= cardB:getEffectiveId() then
						if suit == cardB:getSuit() then
							table.insert(to_use, cardA:getEffectiveId())
							table.insert(to_use, cardB:getEffectiveId())
							break
						end
					end
				end
				if #to_use == 2 then
					break
				end
			end
		end
	elseif case == 6 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			local dummy_use = {
				isDummy = true,
			}
			if c:isKindOf("BasicCard") then
				self:useBasicCard(c, dummy_use)
			elseif c:isKindOf("EquipCard") then
				self:useEquipCard(c, dummy_use)
			elseif c:isKindOf("TrickCard") then
				self:useTrickCard(c, dummy_use)
			end
			if not dummy_use.c then
				table.insert(can_use, c)
			end
		end
		self:sortByUseValue(can_use, true)
		if #can_use >= 3 then
			for i=1, 3, 1 do
				table.insert(to_use, can_use[i]:getEffectiveId())
			end
		end
		if #to_use == 0 and math.random(1, 100) <= 60 then
			can_use = sgs.QList2Table(cards) 
			self:sortByUseValue(can_use, true)
			for i=1, 3, 1 do
				table.insert(to_use, can_use[i]:getEffectiveId())
			end
		end
	elseif case == 7 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("TrickCard") then
				table.insert(can_use, c)
			end
		end
		if #can_use > 0 then
			self:sortByUseValue(can_use, true)
			for _,c in ipairs(can_use) do
				local dummy_use = {
					isDummy = true
				}
				self:useTrickCard(c, dummy_use)
				if not dummy_use.card then
					table.insert(to_use, c:getEffectiveId())
					break
				end
			end
			if #to_use == 0 then
				table.insert(to_use, can_use[1]:getEffectiveId())
			end
		end
	elseif case == 8 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("EquipCard") then
				table.insert(can_use, c)
			end
		end
		if #can_use > 0 then
			self:sortByUseValue(can_use, true)
			for _,c in ipairs(can_use) do
				local dummy_use = {
					isDummy = true
				}
				self:useEquipCard(c, dummy_use)
				if not dummy_use.card then
					table.insert(to_use, c:getEffectiveId())
					break
				end
			end
			if #to_use == 0 then
				table.insert(to_use, can_use[1]:getEffectiveId())
			end
		end
	elseif case == 9 then
		local can_use = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("BasicCard") then
				table.insert(can_use, c)
			end
		end
		if #can_use > 0 then
			self:sortByUseValue(can_use, true)
			for _,c in ipairs(can_use) do
				local dummy_use = {
					isDummy = true
				}
				self:useBasicCard(c, dummy_use)
				if not dummy_use.card then
					table.insert(to_use, c:getEffectiveId())
					break
				end
			end
			if #to_use == 0 then
				table.insert(to_use, can_use[1]:getEffectiveId())
			end
		end
	elseif case == 10 then
		local can_use = self:askForDiscard("dummy", 1, 1, false, true)
		if #can_use > 0 then
			table.insert(to_use, can_use[1])
		end
	end
	if #to_use > 0 then
		local card_str = "#crShiShengUseCard:"..table.concat(to_use, "+")..":->."
		return card_str
	end
	self.room:setPlayerFlag(self.player, "AI_crShiShengFailed")
	return "."
end
--ShiShengCard:Play
local shisheng_skill = {
	name = "crShiSheng",
	getTurnUseCard = function(self, inclusive)
		if self.player:hasFlag("AI_crShiShengFailed") then
			return nil
		end
		local mark = self.player:getMark("@crShiShengMark")
		if mark == 0 then
			return nil
		elseif mark < 7 then
			if self.player:isKongcheng() then
				return nil
			end
		elseif self.player:isNude() then
			return nil
		end
		return sgs.Card_Parse("#crShiShengCard:.:")
	end,
}
table.insert(sgs.ai_skills, shisheng_skill)
sgs.ai_skill_use_func["#crShiShengCard"] = function(card, use, self)
	local mark = self.player:getMark("@crShiShengMark")
	mark = math.min(10, mark)
	local fail = true
	local cards = self.player:getCards("he")
	local count = cards:length()
	if mark == 10 and count > 0 then
		fail = false
	end
	if fail and mark >= 9 then
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("BasicCard") then
				fail = false
				break
			end
		end
	end
	if fail and mark >= 8 then
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("EquipCard") then
				fail = false
				break
			end
		end
	end
	if fail and mark >= 7 then
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("TrickCard") then
				fail = false
				break
			end
		end
	end
	local handcards = self.player:getHandcards()
	local num = handcards:length()
	if fail and mark >= 6 and num >= 3 then
		fail = false
	end
	if fail and mark >= 5 and num >= 2 then
		for _,c in sgs.qlist(handcards) do
			local id = c:getEffectiveId()
			local suit = c:getSuit()
			for _,c2 in sgs.qlist(handcards) do
				if c2:getEffectiveId() ~= id then
					if c2:getSuit() == suit then
						fail = false
						break
					end
				end
			end
			if not fail then
				break
			end
		end
	end
	if fail and mark >= 4 and num > 2 then
		for _,c in sgs.qlist(handcards) do
			local id = c:getEffectiveId()
			local point = c:getNumber()
			for _,c2 in sgs.qlist(handcards) do
				if c2:getEffectiveId() ~= id then
					if c2:getNumber() == point then
						fail = false
						break
					end
				end
			end
			if not fail then
				break
			end
		end
	end
	if fail and mark >= 3 and num >= 2 then
		for _,c in sgs.qlist(handcards) do
			local id = c:getEffectiveId()
			local suit = c:getSuit()
			local point = c:getNumber()
			for _,c2 in sgs.qlist(handcards) do
				if c2:getEffectiveId() ~= id then
					if c2:getSuit() == suit and c2:getNumber() == point then
						fail = false
						break
					end
				end
			end
			if not fail then
				break
			end
		end
	end
	if fail and mark >= 2 then
		for _,c in sgs.qlist(handcards) do
			if c:getNumber() == 10 then
				fail = false
				break
			end
		end
	end
	if fail and mark >= 1 then
		for _,c in sgs.qlist(handcards) do
			if c:getNumber() == 5 then
				fail = false
				break
			end
		end
	end
	if fail then
		if not use.isDummy then
			self.room:setPlayerFlag(self.player, "AI_crShiShengFailed")
		end
		return 
	end
	use.card = card
end
--相关信息
sgs.ai_use_priority["crShiShengCard"] = 3
sgs.ai_event_callback[sgs.EventPhaseEnd].crShiSheng = function(self, player, data)
	if player:getPhase() == sgs.Player_Play then
		if player:hasFlag("AI_crShiShengFailed") then
			self.room:setPlayerFlag(player, "-AI_crShiShengFailed")
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].crShiSheng = function(self, player, data)
	if player:getPhase() == sgs.Player_Play then
		if player:hasFlag("AI_crShiShengFailed") then
			local move = data:toMoveOneTime()
			local target = move.to
			if target and target:objectName() == player:objectName() then
				if move.to_place == sgs.Player_PlaceHand then
					self.room:setPlayerFlag(player, "-AI_crShiShengFailed")
				end
			end
		end
	end
end
--[[****************************************************************
	编号：CCC - 06
	武将：瑶池仙子
	称号：碧水清仙
	势力：神
	性别：女
	体力上限：3勾玉
]]--****************************************************************
--[[
	技能：圣洁（锁定技）
	描述：其他角色计算与你的距离时，始终＋X（X为你的体力值且至多为3）。
]]--
--[[
	技能：弦灵（阶段技）
	描述：你可以弃置至少一张牌，然后根据这些牌的特征依次执行相应的效果。
		1、弃置X张且均为黑桃牌：指定至多X名角色依次失去一点体力，然后各摸一张牌；
		2、弃置X张且均为红心牌：指定至多X名角色依次回复一点体力，然后各弃一张牌；
		3、弃置X张且均为草花牌：指定至多X名角色依次进入或解除连环状态；
		4、弃置X张且均为方块牌：指定至多X名角色依次使用一张【杀】，否则你获得其一张牌；
		5、弃置包括X张黑色牌（X至少为3）：视为你使用了一张【南蛮入侵】，且该【南蛮入侵】造成雷电属性的伤害；
		6、弃置包括X张红色牌（X至少为3）：视为你使用了一张【万箭齐发】，且该【万箭齐发】造成火焰属性的伤害；
		7、弃置包括X张点数大于10的牌：指定至多X名角色依次将武将牌翻面；
		8、弃置包括X张点数小于4的牌：指定至多X名角色依次受到一点伤害，然后各回复一点体力；
		9、弃置X张且点数均相连的牌（X至少为2）：指定至多一名角色流失（X-2）点体力上限，然后摸X张牌；
		10、弃置X张且点数均相同的牌（X至少为2）：指定至多X名角色按座次轮换手牌；
		11、弃置X张且点数之和为完全平方数：指定至多一名角色，所有其他角色依次获得该角色的一张牌；
		12、弃置四种花色的牌各至少一张：指定至多一名角色失去一项技能；
]]--
--room:askForDiscard(p, "crXianLing", 1, 1, false, true)
--room:askForUseCard(p, "slash", prompt, -1, sgs.Card_MethodUse, false)
--room:askForCardChosen(source, p, "he", "crXianLing")
--room:askForCardChosen(p, victim, "he", "crXianLing")
--room:askForChoice(source, "crXianLing", choices, ai_data)
function getSkillLevel(self, target, skill)
	if type(skill) == "userdata" then
		skill = skill:objectName()
	end
	local groupA = {"benghuai", "wumou", "shiyong", "yaowu", "zaoyao", "chanyuan", "chouhai"}
	for _,item in ipairs(groupA) do
		if skill == item then
			return -10
		end
	end
	local groupB = {"wuyan", "noswuyan", "wenjiu", "tongji", "huoshou", "jinjiu"}
	for _,item in ipairs(groupB) do
		if skill == item then
			return -9
		end
	end
	if target:getMark("@waked") > 0 then
		if item == "zaoxian" and target:hasSkill("jixi") then
			return -8
		elseif item == "zhiji" and target:hasSkill("guanxing") then
			return -8
		elseif item == "ruoyu" and target:hasLordSkill("jijiang") then
			return -8
		elseif item == "hunzi" and target:hasSkill("yinghun") and target:hasSkill("yingzi") then
			return -8
		elseif item == "baiyin" and target:hasSkill("jilve") then
			return -8
		elseif item == "zili" and target:hasSkill("paiyi") then
			return -8
		elseif item == "zhanshen" and target:hasSkill("mashu") and target:hasSkill("shenji") then
			return -8
		elseif item == "danji" and target:hasSkill("mashu") then
			return -8
		elseif item == "wuji" and not target:hasSkill("huxiao") then
			return -8
		elseif item == "kegou" and target:hasSkill("lianying") then
			return -8
		elseif item == "jiehuo" and target:hasSkill("shien") then
			return -8
		end
	end
	if item == "niepan" and target:getMark("@nirvana") == 0 then
		return -8
	elseif item == "luanwu" and target:getMark("@chaos") == 0 then
		return -8
	elseif item == "qixing" and target:getPile("star"):isEmpty() then
		return -8
	elseif item == "jiefan" and target:getMark("@rescue") == 0 then
		return -8
	elseif item == "fuli" and target:getMark("@laoji") == 0 then
		return -8
	elseif item == "fencheng" and target:getMark("@burn") == 0 then
		return -8
	elseif item == "nosfencheng" and target:getMark("@nosburn") == 0 then
		return -8
	elseif item == "fenxin" and target:getMark("@burnheart") == 0 then
		return -8
	elseif item == "zhongyi" and target:getMark("@loyal") == 0 then
		return -8
	elseif item == "xiechan" and target:getMark("@twine") == 0 then
		return -8
	elseif item == "zuixiang" and target:getMark("@sleep") == 0 then
		return -8
	elseif item == "xiongyi" and target:getMark("@arise") == 0 then
		return -8
	end
	local groupW = ( sgs.masochism_skill.."|"..sgs.recover_skill.."|" ):split("|")
	for _,item in ipairs(groupW) do
		if item == skill then
			return 7
		end
	end
	local groupX = ( sgs.exclusive_skill.."|"..sgs.cardneed_skill ):split("|")
	for _,item in ipairs(groupX) do
		if item == skill then
			return 8
		end
	end
	local groupY = ( sgs.lose_equip_skill.."|"..sgs.drawpeach_skill.."|"..sgs.save_skill ):split("|")
	for _,item in ipairs(groupY) do
		if item == skill then
			return 9
		end
	end
	local groupZ = sgs.priority_skill:split("|")
	for _,item in ipairs(groupZ) do
		if item == skill then
			return 10
		end
	end
	return 0
end
sgs.ai_skill_choice["crXianLing"] = function(self, choices, data)
	local target = data:toPlayer()
	local skills = choices:split("+")
	local maxLevel, maxSkill = -999, nil
	local minLevel, minSkill = 999, nil
	for _,skill in ipairs(skills) do
		local level = getSkillLevel(self, target, skill)
		if level > maxLevel then
			maxLevel = level
			maxSkill = skill
		end
		if level < minLevel then
			minLevel = level
			minSkill = skill
		end
	end
	if self:isFriend(target) then
		return minSkill
	else
		return maxSkill
	end
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingAResult(self, count)
	--指定至多X名角色依次流失一点体力，然后各摸一张牌
	local alives = self.room:getAlivePlayers()
	local getValue = function(target)
		local v = 0
		local isFriend = ( self:isFriend(target) )
		local hp = target:getHp()
		local dieFlag = false
		v = v + 2
		if hp <= 1 then
			v = v + 0.5
			if self:getAllPeachNum(target) == 0 then
				dieFlag = true
				v = v + 20
			end
		end
		if self:needToLoseHp(target) then
			v = v - 0.8
		end
		if self:hasSkills(sgs.masochism_skill, target) then
			v = v + 0.5
		end
		v = v + ( 5 - hp ) * 0.1
		if isFriend then
			v = - v
		end
		if dieFlag then
			if target:isLord() then
				if self.role == "renegade" and self.room:alivePlayerCount() > 2 then
					v = v - 100
				end
			else
				if target:hasSkill("wuhun") then
					local victims = self:getWuhunRevengeTargets()
					local lord = getLord(self.player)
					if lord and #victims > 0 then
						for _,p in ipairs(victims) do
							if p:objectName() == lord:objectName() then
								v = v - 100
								break
							end
						end
					end
				end
			end
		else
			if isFriend then
				v = v + 1
			else
				v = v - 1
			end
			if target:isKongcheng() and self:needKongcheng(target, true) then
				if isFriend then
					v = v - 0.8
				else
					v = v + 0.8
				end
			end
		end
		return v
	end
	local values = {}
	local players = {}
	for _,p in sgs.qlist(alives) do
		values[p:objectName()] = getValue(p)
		table.insert(players, p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local targets = {} 
	for index, p in ipairs(players) do
		if index <= count then
			local v = values[p:objectName()] or 0
			if v > 0 then
				table.insert(targets, p:objectName())
			end
		else
			break
		end
	end
	if #targets > 0 then
		return "#crXianLingACard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingBResult(self, count)
	--指定至多X名角色依次回复一点体力，然后各弃一张牌
	local alives = self.room:getAlivePlayers()
	local getValue = function(target)
		local v = 0
		local isFriend = ( self:isFriend(target) )
		if target:isWounded() then
			v = v - 2
			if getBestHp(target) >= target:getHp() then
				v = v - 0.6
			end
		end
		if not target:isNude() then
			v = v + 1
			if target:hasEquip() then
				if self:hasSkills(sgs.lose_equip_skill, target) then
					v = v - 2
				end
				if self:needToThrowArmor(target) then
					v = v - 2
				end
			end
		end
		if isFriend then
			v = - v
		end
		return v
	end
	local values = {}
	local players = {}
	for _,p in sgs.qlist(alives) do
		values[p:objectName()] = getValue(p)
		table.insert(players, p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local targets = {}
	for index, p in ipairs(players) do
		if index <= count then
			local v = values[p:objectName()] or 0
			if v > 0 then
				table.insert(targets, p:objectName())
			end
		else
			break
		end
	end
	if #targets > 0 then
		return "#crXianLingBCard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingCResult(self, count)
	--指定至多X名角色依次进入或解除连环状态
	local players = {}
	for _,friend in ipairs(self.friends) do
		if friend:isChained() then
			table.insert(players, friend)
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if not enemy:isChained() then
			table.insert(players, enemy)
		end
	end
	local targets = {}
	for index, p in ipairs(players) do
		if index <= count then
			table.insert(targets, p:objectName())
		else
			break
		end
	end
	if #targets > 0 then
		return "#crXianLingCCard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingDResult(self, count)
	--指定至多X名角色依次使用一张【杀】，否则你获得其一张牌
	local alives = self.room:getAlivePlayers()
	local getValue = function(target)
		local value = 0
		local isFriend = ( self:isFriend(target) )
		local isMyself = ( target:objectName() == self.player:objectName() )
		local slashNum = 0
		if isMyself then
			slashNum = self:getCardsNum("Slash", "he", false) 
		else
			slashNum = getCardsNum("Slash", target)
		end
		local victims = {}
		for _,p in sgs.qlist(alives) do
			if target:canSlash(p) then
				table.insert(victims, p)
			end
		end
		if isFriend then
			if target:getArmor() and self:needToThrowArmor(target) then
				value = value + 2
			elseif slashNum > 0 then
				local max_v = 0
				for _,victim in ipairs(victims) do
					local v = 0
					if self:isFriend(victim) then
						v = v - 1
						if victim:hasSkill("leiji") then
							if getCardsNum("Jink", victim) > 0 then
								v = v + 2
								if victim:isWounded() then
									v = v + 2
								end
							end
						elseif victim:hasSkill("nosleiji") then
							if getCardsNum("Jink", victim) > 0 then
								v = v + 4
							end
						end
					else
						v = v - 1
						if self:slashProhibit(nil, victim, target) then
							v = v - 1
						else
							v = v + 2
						end
					end
					if v > max_v then
						max_v = v
					end
				end
				value = value + max_v
			end
		else
			local isSafe = false
			if slashNum == 0 or #victims == 0 then
				isSafe = true
			else
				isSafe = true
				for _,victim in ipairs(victims) do
					if self:isFriend(victim) then
						if self:damageIsEffective(victim, sgs.DamageStruct_Normal, target) then
							if not self:cantbeHurt(victim, target, 1) then
								isSafe = false
								break
							end
						end
					end
				end
			end
			if isSafe then
				if not target:isNude() then
					value = value + 1
					if target:hasSkill("tuntian") then
						value = value - 0.3
					end
				end
				local equips = target:getEquips()
				if equips:isEmpty() then
					if target:getHandcardNum() == 1 and self:needKongcheng(target) then
						value = value - 0.4
					end
				else
					if target:isKongcheng() then
						if self:hasSkills(sgs.lose_equip_skill, target) then
							value = value - 2
						end
						if equips:length() == 1 and self:needToThrowArmor(target) then
							value = value - 2
						end
					end
				end
			else
				value = value - 2
			end
		end
		return v
	end
	local values = {}
	local players = {}
	for _,p in sgs.qlist(alives) do
		values[p:objectName()] = getValue(p)
		table.insert(players, p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local targets = {}
	for index, p in ipairs(players) do
		if index <= count then
			local v = values[p:objectName()] or 0
			if v > 0 then
				table.insert(targets, p:objectName())
			end
		else
			break
		end 
	end
	if #targets > 0 then
		return "#crXianLingDCard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--source:askForSkillInvoke("crXianLingE", sgs.QVariant("invoke"))
sgs.ai_skill_invoke["crXianLingE"] = function(self, data)
	local aoe = sgs.Sanguosha:cloneCard("savage_assault", sgs.Card_NoSuit, 0)
	aoe:deleteLater()
	local dummy_use = {
		isDummy = true,
	}
	self:useTrickCard(aoe, dummy_use)
	if dummy_use.card then
		return true
	end
	return false
end
--source:askForSkillInvoke("crXianLingF", sgs.QVariant("invoke"))
sgs.ai_skill_invoke["crXianLingF"] = function(self, data)
	local aoe = sgs.Sanguosha:cloneCard("archery_attack", sgs.Card_NoSuit, 0)
	aoe:deleteLater()
	local dummy_use = {
		isDummy = true,
	}
	self:useTrickCard(aoe, dummy_use)
	if dummy_use.card then
		return true
	end
	return false
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingGResult(self, count)
	--指定至多X名角色依次将武将牌翻面
	local targets = {}
	self:sort(self.friends, "defense")
	for _,p in ipairs(self.friends) do
		if not self:toTurnOver(p, 0, "ComXianLing") then
			table.insert(targets, p:objectName())
			if #targets >= count then
				break
			end
		end
	end
	if #targets < count then
		self:sort(self.enemies, "threat")
		for _,p in ipairs(self.enemies) do
			if self:toTurnOver(p, 0, "ComXianLing") then
				table.insert(targets, p:objectName())
				if #targets >= count then
					break
				end
			end
		end
	end
	if #targets > 0 then
		return "#crXianLingGCard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingHResult(self, count)
	--指定至多X名角色依次受到一点伤害，然后各回复一点体力
	local alives = self.room:getAlivePlayers()
	local skills = "yiji|jieming|fangzhu|huashen|guixin|kuangbao|renjie|quanji|zhiyu|chengxiang|fenyong|tongxin|nosenyuan"
	local getValue = function(target)
		local v = 0
		local isFriend = ( self:isFriend(target) )
		local damage = true
		if target:getMark("@fenyong") > 0 then
			damage = false
		elseif target:getMark("@fog") > 0 then
			damage = false
		end
		local dieFlag = false
		if damage then
			v = v + 2
			local hp = target:getHp()
			if hp <= 1 and self:getAllPeachNum(target) == 0 then
				dieFlag = true
				v = v + 20
			end
			if self:hasSkills(skills, target) then
				v = v - 2
			end
			if isFriend then
				v = - v
			end
		end
		if dieFlag then
			if self.role == "renegade" and target:isLord() and self.room:alivePlayerCount() > 2 then
				v = v - 100
			elseif target:hasSkill("wuhun") then
				local victims = self:getWuhunRevengeTargets()
				local lord = getLord(self.player)
				if lord and #victims > 0 then
					for _,p in ipairs(victims) do
						if p:objectName() == lord:objectName() then
							v = v - 100
							break
						end
					end
				end
			end
		else
			if isFriend then
				v = v + 2
			else
				v = v - 2
			end
		end
		return v
	end
	local values = {}
	local players = {}
	for _,p in sgs.qlist(alives) do
		values[p:objectName()] = getValue(p)
		table.insert(players, p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local targets = {}
	for index, p in ipairs(players) do
		if index <= count then
			local value = values[p:objectName()] or 0
			if value > 0 then
				table.insert(targets, p:objectName())
			end
		else
			break
		end
	end
	if #targets > 0 then
		return "#crXianLingHCard:.:->"..table.concat(targets, "+")
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingIResult(self, count)
	--指定至多一名角色流失（X-2）点体力上限，然后摸X张牌
	if count > 2 then
		local to_lose = count - 2
		if #self.enemies > 0 then
			self:sort(self.enemies, "threat")
			for _,enemy in ipairs(self.enemies) do
				if enemy:getMaxHp() <= to_lose then
					local can_die = true
					if self.role == "renegade" and enemy:isLord() and self.room:alivePlayerCount() > 2 then
						can_die = false
					elseif enemy:hasSkill("wuhun") then
						local victims = self:getWuhunRevengeTargets()
						local lord = getLord(self.player)
						if lord and #victims > 0 then
							for _,victim in ipairs(victims) do
								if victim:objectName() == lord:objectName() then
									can_die = false
									break
								end
							end
						end
					end
					if can_die then
						return "#crXianLingICard:.:->"..enemy:objectName()
					end
				end
			end
			for _,enemy in ipairs(self.enemies) do
				if self:willSkipPlayPhase(enemy) or hasManjuanEffect(enemy) then
					return "#ComXianLingICard:.:->"..enemy:objectName()
				end
			end
			return "#crXianLingICard:.:->"..self.enemies[1]:objectName()
		end
	else
		local target = self:findPlayerToDraw(true, count)
		if target then
			return "#crXianLingICard:.:->"..target:objectName()
		end
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingJResult(self, count)
	--指定至多X名角色按座次轮换手牌
	local friends = {}
	for _,friend in ipairs(self.friends) do
		if not hasManjuanEffect(friend) then
			table.insert(friends, friend)
		end
	end
	if #friends == 0 then
		return "."
	end
	local compare_func = function(a, b)
		local numA = a:getHandcardNum() - self:getLeastHandcardNum(a)
		local numB = a:getHandcardNum() - self:getLeastHandcardNum(b)
		return numA < numB
	end
	table.sort(friends, compare_func)
	if #self.enemies == 0 then
		if #friends > 1 then
			local DengAi, LuXun, other = nil, nil
			for _,friend in ipairs(friends) do
				if friend:hasSkill("tuntian") then
					DengAi = friend
				elseif self:getLeastHandcardNum(friend) > 0 then
					LuXun = friend
				elseif not other then
					other = friend
				end
			end
			if DengAi and LuXun then
				return string.format("#crXianLingJCard:.:->%s+%s", DengAi:objectName(), LuXun:objectName())
			elseif DengAi and other then
				return string.format("#crXianLingJCard:.:->%s+%s", DengAi:objectName(), other:objectName())
			elseif LuXun and other then
				return string.format("#crXianLingJCard:.:->%s+%s", LuXun:objectName(), other:objectName())
			end
		end
	else
		self:sort(self.enemies, "threat")
		for _,enemy in ipairs(self.enemies) do
			if hasManjuanEffect(enemy) then
				if enemy:getHandcardNum() >= friends[1]:getHandcardNum() then
					return string.format("#crXianLingJCard:.:->%s+%s", friends[1]:objectName(), enemy:objectName())
				elseif #self.enemies > 1 then
					for _,enemy2 in ipairs(self.enemies) do
						if enemy:objectName() ~= enemy2:objectName() then
							return string.format("#crXianLingJCard:.:->%s+%s", enemy:objectName(), enemy2:objectName())
						end
					end
				else
					return string.format("#crXianLingJCard:.:->%s+%s", friends[1]:objectName(), enemy:objectName())
				end
			end
		end
		for _,enemy in ipairs(self.enemies) do
			local numA = enemy:getHandcardNum()
			local numAX = numA - self:getLeastHandcardNum(enemy)
			local peachA = getCardsNum("Peach", enemy, self.player)
			for _,friend in ipairs(friends) do
				local numB = friend:getHandcardNum()
				local numBX = numB - self:getLeastHandcardNum(friend)
				local peachB = 0
				if friend:objectName() == self.player:objectName() then
					peachB = self:getCardsNum("Peach")
				else
					peachB = getCardsNum("Peach", friend, self.player)
				end
				local worth = true
				if numA < numB then
					worth = false
				elseif numAX <= numBX and peachA < peachB then
					worth = false
				elseif peachA == 0 and peachB > 0 then
					worth = false
				elseif numA == numB and numA > 0 and enemy:hasSkill("tuntian") then
					worth = false
				end
				if worth then
					return string.format("#crXianLingJCard:.:->%s+%s", friend:objectName(), enemy:objectName())
				end
			end
		end
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingKResult(self)
	--指定至多一名角色，所有其他角色依次获得该角色的一张牌
	local alives = self.room:getAlivePlayers()
	local getValue = function(target)
		local v = 0
		local equips = target:getEquips()
		local equipNum = equips:length()
		local num = target:getHandcardNum()
		local allNum = num + equipNum
		local count = self.room:alivePlayerCount()
		count = math.min(count, allNum)
		if target:hasSkill("tuntian") then
			v = v - count * 0.3
		end
		local isFriend = ( self:isFriend(target) )
		local others = {}
		local support, against = 0, 0
		local this_player = self.player
		for i=1, count, 1 do
			if this_player:objectName() ~= target:objectName() then
				table.insert(others, this)
				if self:isFriend(this_player, target) then
					support = support + 1
				else
					against = against + 1
				end
			end
			this_player = this_player:getNextAlive()
		end
		v = v + count - support + against
		if equipNum > 0 then
			if self:hasSkills(sgs.lose_equip_skills, target) then
				if num >= against then
					v = v - math.min(support, equipNum) * 2
				else
					v = v - equipNum * 2
				end
			end
			if support > 0 and target:getArmor() and self:needToThrowArmor(target) then
				v = v - 2
			end
		end
		if isFriend then
			v = - v
		end
		return v
	end
	local values = {}
	local players = {}
	for _,p in sgs.qlist(alives) do
		values[p:objectName()] = getValue(p)
		table.insert(players, p)
	end
	local compare_func = function(a, b)
		local valueA = values[a:objectName()] or 0
		local valueB = values[b:objectName()] or 0
		return valueA > valueB
	end
	table.sort(players, compare_func)
	local target = players[1]
	local value = values[target:objectName()]
	if value > 0 then
		return "#crXianLingKCard:.:->"..target:objectName()
	end
	return "."
end
--room:askForUseCard(source, "@@crXianLing", prompt)
function getXianLingLResult(self)
	--指定至多一名角色失去一项技能
	for _,friend in ipairs(self.friends) do
		if self:hasSkills("benghuai|wumou|shiyong|yaowu|zaoyao|yaowu|chouhai", friend) then
			return "#crXianLingLCard:.:->"..friend:objectName()
		end
	end
	local maxLevel, target = -1, nil
	self:sort(self.enemies, "threat")
	for _,enemy in ipairs(self.enemies) do
		local skills = enemy:getVisibleSkillList()
		for _,skill in sgs.qlist(skills) do
			if skill:inherits("SPConvertSkill") then
			elseif skill:isAttachedLordSkill() then
			else
				local level = getSkillLevel(self, enemy, skill)
				if level > maxLevel then
					maxLevel = level
					target = enemy
				end
			end
		end
	end
	if target and maxLevel >= 0 then
		return "#crXianLingLCard:.:->"..target:objectName()
	end
	return "."
end
sgs.ai_skill_use["@@crXianLing"] = function(self, prompt, method)
	local case = self.player:getMark("crXianLingType")
	local count = self.player:getMark("crXianLingCount")
	if case == 1 then
		return getXianLingAResult(self, count)
	elseif case == 2 then
		return getXianLingBResult(self, count)
	elseif case == 3 then
		return getXianLingCResult(self, count)
	elseif case == 4 then
		return getXianLingDResult(self, count)
	elseif case == 7 then
		return getXianLingGResult(self, count)
	elseif case == 8 then
		return getXianLingHResult(self, count)
	elseif case == 9 then
		local data = self.player:getMark("crXianLingData")
		return getXianLingIResult(self, data)
	elseif case == 10 then
		return getXianLingJResult(self, count)
	elseif case == 11 then
		return getXianLingKResult(self)
	elseif case == 12 then
		return getXianLingLResult(self)
	end
	return "."
end
--XianLingCard:Play
local xianling_skill = {
	name = "crXianLing",
	getTurnUseCard = function(self, inclusive)
		if self.player:isNude() then
			return nil
		elseif self.player:hasUsed("#crXianLingCard") then
			return nil
		end
		return sgs.Card_Parse("#crXianLingCard:.:")
	end,
}
table.insert(sgs.ai_skills, xianling_skill)
sgs.ai_skill_use_func["#crXianLingCard"] = function(card, use, self)
	local cards = self.player:getCards("he")
	cards = sgs.QList2Table(cards)
	self:sortByUseValue(cards, true)
	local spades, hearts, clubs, diamonds = {}, {}, {}, {}
	local blacks, reds, bigs, smalls = {}, {}, {}, {}
	for _,c in ipairs(cards) do
		local suit = c:getSuit()
		if suit == sgs.Card_Spade then
			table.insert(spades, c)
			table.insert(blacks, c)
		elseif suit == sgs.Card_Heart then
			table.insert(hearts, c)
			table.insert(reds, c)
		elseif suit == sgs.Card_Club then
			table.insert(clubs, c)
			table.insert(blacks, c)
		elseif suit == sgs.Card_Diamond then
			table.insert(diamonds, c)
			table.insert(reds, c)
		end
		local point = c:getNumber()
		if point > 10 then
			table.insert(bigs, c)
		elseif point < 4 then
			table.insert(smalls, c)
		end
	end
	local SpadeNum, HeartNum, ClubNum, DiamondNum = #spades, #hearts, #clubs, #diamonds
	local BlackNum, RedNum, BigNum, SmallNum = #blacks, #reds, #bigs, #smalls
	local NeedSavageAssault, NeedArcheryAttack, NeedDetachSkill = false, false, false
	if BlackNum >= 3 then
		local aoe = sgs.Sanguosha:cloneCard("savage_assault", sgs.Card_NoSuit, 0)
		aoe:deleteLater()
		local dummy_use = {
			isDummy = true,
		}
		self:useTrickCard(aoe, dummy_use)
		if dummy_use.card and dummy_use.card:isKindOf("SavageAssault") then
			NeedSavageAssault = true
		end
	end
	if RedNum >= 3 then
		local aoe = sgs.Sanguosha:cloneCard("archery_attack", sgs.Card_NoSuit, 0)
		aoe:deleteLater()
		local dummy_use = {
			isDummy = true,
		}
		self:useTrickCard(aoe, dummy_use)
		if dummy_use.card and dummy_use.card:isKindOf("ArcheryAttack") then
			NeedArcheryAttack = true
		end
	end
	if SpadeNum > 0 and HeartNum > 0 and ClubNum > 0 and DiamondNum > 0 then
		for _,enemy in ipairs(self.enemies) do
			local skills = enemy:getVisibleSkillList()
			for _,skill in sgs.qlist(skills) do
				if skill:inherits("SPConvertSkill") then
				elseif skill:isAttachedLordSkill() then
				elseif string.find("benghuai|shiyong|wumou|yaowu|zaoyao|chanyuan|chouhai", skill:objectName()) then
				else
					NeedDetachSkill = true
					break
				end
			end
			if NeedDetachSkill then
				break
			end
		end
		if not NeedDetachSkill then
			for _,friend in ipairs(self.friends) do
				local skills = friend:getVisibleSkillList()
				for _,skill in sgs.qlist(skills) do
					if string.find("benghuai|shiyong|wumou|yaowu|zaoyao|chanyuan|chouhai", skill:objectName()) then
						NeedDetachSkill = true
						break
					end
				end
				if NeedDetachSkill then
					break
				end
			end
		end
	end
	if NeedDetachSkill then
		if NeedSavageAssault then
			local spade, club, black = nil, nil, nil
			for _,c in ipairs(blacks) do
				local suit = c:getSuit()
				if suit == sgs.Card_Spade then
					if not spade then
						spade = c:getEffectiveId()
					elseif not black then
						black = c:getEffectiveId()
					end
				elseif suit == sgs.Card_Club then
					if not club then
						club = c:getEffectiveId()
					elseif not black then
						black = c:getEffectiveId()
					end
				end
				if spade and club and black then
					break
				end
			end
			if spade and club and black then
				local heart, diamond = hearts[1]:getEffectiveId(), diamonds[1]:getEffectiveId()
				if NeedArcheryAttack then
					local red = diamonds[2] or hearts[2]
					if red then
						red = red:getEffectiveId()
						local card_str = string.format(
							"#crXianLingCard:%d+%d+%d+%d+%d+%d:", 
							spade, heart, club, diamond, black, red
						)
						local acard = sgs.Card_Parse(card_str)
						use.card = acard
						return 
					end
				end
				local card_str = string.format("#crXianLingCard:%d+%d+%d+%d+%d:", spade, heart, club, diamond, black)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				return 
			end
		end
		if NeedArcheryAttack then
			local heart, diamond, red = nil, nil, nil
			for _,c in ipairs(reds) do
				local suit = c:getSuit()
				if suit == sgs.Card_Heart then
					if not heart then
						heart = c:getEffectiveId()
					elseif not red then
						red = c:getEffectiveId()
					end
				elseif suit == sgs.Card_Diamond then
					if not diamond then
						diamond = c:getEffectiveId()
					elseif not red then
						red = c:getEffectiveId()
					end
				end
				if heart and diamond and red then
					break
				end
			end
			if heart and diamond and red then
				local spade = spades[1]:getEffectiveId()
				local club = clubs[1]:getEffectiveId()
				local card_str = string.format("#crXianLingCard:%d+%d+%d+%d+%d:", spade, heart, club, diamond, red)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				return 
			end
		end
	end
	if NeedSavageAssault then
		if SpadeNum >= 3 then
			local to_use = {}
			for i=1, 3, 1 do
				table.insert(to_use, spades[i]:getEffectiveId())
			end
			local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
		if ClubNum >= 3 then
			local to_use = {}
			for i=1, 3, 1 do
				table.insert(to_use, clubs[i]:getEffectiveId())
			end
			local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
		local to_use = {}
		for i=1, 3, 1 do
			table.insert(to_use, blacks[i]:getEffectiveId())
		end
		local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
		return 
	end
	if NeedArcheryAttack then
		if HeartNum >= 3 then
			local to_use = {}
			for i=1, 3, 1 do
				table.insert(to_use, hearts[i]:getEffectiveId())
			end
			local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
		if DiamondNum >= 3 then
			local to_use = {}
			for i=1, 3, 1 do
				table.insert(to_use, diamonds[i]:getEffectiveId())
			end
			local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
		local to_use = {}
		for i=1, 3, 1 do
			table.insert(to_use, reds[i]:getEffectiveId())
		end
		local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
		return 
	end
	if NeedDetachSkill then
		local spade = spades[1]:getEffectiveId()
		local heart = hearts[1]:getEffectiveId()
		local club = clubs[1]:getEffectiveId()
		local diamond = diamonds[1]:getEffectiveId()
		local card_str = string.format("#crXianLingCard:%d+%d+%d+%d:", spade, heart, club, diamond)
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
		return 
	end
	if BigNum > 0 then
		local alives = self.room:getAlivePlayers()
		local count = 0
		for _,p in sgs.qlist(alives) do
			if self:isFriend(p) then
				if not self:toTurnOver(p, 0, "crXianLing") then
					count = count + 1
				end
			else
				if self:toTurnOver(p, 0, "crXianLing") then
					count = count + 1
				end
			end
			if count >= BigNum then
				break
			end
		end
		local to_use = {}
		for index, c in ipairs(bigs) do
			if index <= count then
				table.insert(to_use, c:getEffectiveId())
			else
				break
			end
		end
		if #to_use > 0 then
			local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
	end
	if SmallNum > 0 then
		local count = 0
		local skills = "yiji|jieming|fangzhu|huashen|guixin|kuangbao|renjie|quanji|zhiyu|chengxiang|fenyong|tongxin|nosenyuan"
		for _,friend in ipairs(self.friends) do
			if self:hasSkills(skills, friend) then
				if friend:getHp() > 1 or self:getAllPeachNum(friend) > 0 then
					count = count + 1
				end
			elseif friend:isWounded() then
				if friend:getMark("@fenyong") > 0 or friend:getMark("@fog") > 0 then
					count = count + 1
				end
			end
			if count >= SmallNum then
				break
			end
		end
		if count < SmallNum then
			for _,enemy in ipairs(self.enemies) do
				if enemy:getHp() <= 1 and self:getAllPeachNum(enemy) == 0 then
					if enemy:getMark("@fenyong") == 0 and enemy:getMark("@fog") == 0 then
						count = count + 1
					end
				end
				if count >= SmallNum then
					break
				end
			end
		end
		if count > 0 then
			local to_use = {}
			for index, c in ipairs(smalls) do
				if index <= count then
					table.insert(to_use, c:getEffectiveId())
				else
					break
				end
			end
			if #to_use > 0 then
				local card_str = "#crXianLingCard:"..table.concat(to_use, "+")..":"
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				return 
			end
		end
	end
	local overflow = self:getOverflow()
	if overflow > 0 then
		local handcards = self.player:getHandcards()
		local groupA, groupB = {}, {}
		for _,c in sgs.qlist(handcards) do
			local point = c:getNumber()
			if point == 1 or point == 4 or point == 9 then
				table.insert(groupA, c)
			else
				table.insert(groupB, c)
			end
		end
		if #groupA > 0 then
			self:sortByUseValue(groupA, true)
			local card_str = "#crXianLingCard:"..groupA[1]:getEffectiveId()..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
		if #groupB > 0 then
			self:sortByUseValue(groupB, true)
			local heart, spade = nil, nil
			for _,c in ipairs(groupB) do
				local suit = c:getSuit()
				if suit == sgs.Card_Heart then
					if not heart then
						heart = c:getEffectiveId()
					end
				elseif suit == sgs.Card_Spade then
					if not spade then
						spade = c:getEffectiveId()
					end
				end
				if heart and spade then
					break
				end
			end
			if heart then
				for _,friend in ipairs(self.friends) do
					if friend:isWounded() and self:isWeak(friend) then
						local card_str = "#crXianLingCard:"..heart..":"
						local acard = sgs.Card_Parse(card_str)
						use.card = acard
						return 
					end
				end
			end
			if spade then
				for _,enemy in ipairs(self.enemies) do
					if enemy:getHp() <= 1 then
						local card_str = "#crXianLingCard:"..spade..":"
						local acard = sgs.Card_Parse(card_str)
						use.card = acard
						return 
					end
				end
			end
			if spade or heart then
				local card_str = "#crXianLingCard:"..( spade or heart )..":"
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				return 
			end
			card_str = "#crXianLingCard:"..groupB[1]:getEffectiveId()..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			return 
		end
	end
end
--相关信息
sgs.ai_use_priority["crXianLingCard"] = 8.5
sgs.ai_use_value["crXianLingCard"] = 10
sgs.ai_card_intention["crXianLingACard"] = function(self, card, from, tos)
	for _,to in ipairs(tos) do
		if to:getHp() <= 1 then
			if to:getHp() + self:getAllPeachNum(to) <= 1 then
				sgs.updateIntention(from, to, 100)
				continue
			end
		end
		if to:getHp() > getBestHp(to) then
			continue
		end
		if hasManjuanEffect(to) then
			sgs.updateIntention(from, to, 80)
			continue
		end
		if not self:needToLoseHp(to) then
			sgs.updateIntention(from, to, 50)
		end
	end
end
sgs.ai_card_intention["crXianLingBCard"] = function(self, card, from, tos)
	for _,to in ipairs(tos) do
		if to:isNude() then
			if to:getHp() < getBestHp(to) then
				sgs.updateIntention(from, to, -70)
			end
		elseif to:getLostHp() == 0 then
			if to:getArmor() and self:needToThrowArmor(to) then
			elseif to:getEquips() and self:hasSkills(sgs.lose_equip_skill, to) then
			elseif to:getHandcardNum() == 1 and self:needKongcheng(to) then
			elseif to:hasSkill("lirang") and #self:getFriendsNoself(to) > 0 then
			elseif self:hasSkills("tuntian", to) then
			else
				sgs.updateIntention(from, to, 80)
			end
		elseif to:hasSkill("shushen") or self:isWeak(to) then
			sgs.updateIntention(from, to, -40)
		end
	end
end
sgs.ai_card_intention["crXianLingCCard"] = function(self, card, from, tos)
	for _,to in ipairs(tos) do
		if to:isChained() then
			sgs.updateIntention(from, to, -10)
		elseif self:isGoodChainTarget(to) then
		elseif self:isGoodChainPartner(to) then
		else
			sgs.updateIntention(from, to, 10)
		end
	end
end
sgs.ai_card_intention["crXianLingDCard"] = function(self, card, from, tos)
	--不更新仇恨值
end
sgs.ai_card_intention["crXianLingGCard"] = function(self, card, from, tos)
	for _,to in ipairs(tos) do
		if self:toTurnOver(to, 0, "crXianLing") then
			sgs.updateIntention(from, to, 25)
		else
			sgs.updateIntention(from, to, -25)
		end
	end
end
sgs.ai_card_intention["crXianLingHCard"] = function(self, card, from, tos)
	local skills = "guixin|yiji|nosyiji|jieming|fenyong|fangzhu|quanji|zhiyu|renjie|tongxin"
	skills = skills.."|huashen|chengxiang|noschengxiang|shushen"
	for _,to in ipairs(tos) do
		if to:getHp() <= 1 then
			if to:getHp() + self:getAllPeachNum(to) <= 1 then
				sgs.updateIntention(from, to, 100)
				continue
			end
		end
		if self:hasSkills(skills, to) then
			sgs.updateIntention(from, to, -80)
		end
	end
end
sgs.ai_card_intention["crXianLingICard"] = function(self, card, from, tos)
	local x = self.player:getMark("crXianLingData")
	if x == 2 then
		for _,to in ipairs(tos) do
			if not hasManjuanEffect(to) then
				sgs.updateIntention(from, to, -50)
			end
		end
	else
		for _,to in ipairs(tos) do
			if x - 2 >= to:getMaxHp() then
				sgs.updateIntention(from, to, 400)
			elseif hasManjuanEffect(to) then
				sgs.updateIntention(from, to, 100)
			elseif self:willSkipPlayPhase(to) then
				sgs.updateIntention(from, to, 80)
			end
		end
	end
end
sgs.ai_card_intention["crXianLingJCard"] = function(self, card, from, tos)
	local support, against = nil, nil
	local minNum, maxNum = 9999, -1
	for _,to in ipairs(tos) do
		local num = to:getHandcardNum()
		if num > maxNum then
			maxNum = num
			against = to
		end
		if num < minNum then
			minNum = num
			support = to
		end
	end
	if support and against and maxNum > minNum then
		local roleA = sgs.evaluatePlayerRole(support)
		local roleB = sgs.evaluatePlayerRole(against)
		if roleA == "neutral" and roleB ~= "neutral" then
			sgs.updateIntention(from, against, 40)
		elseif roleA ~= "neutral" and roleB == "neutral" then
			sgs.updateIntention(from, support, -40)
		elseif roleA == "neutral" and roleB == "neutral" then
			sgs.updateIntention(from, against, 40)
			sgs.updateIntention(from, support, -40)
		else
			sgs.updateIntention(from, support, -40)
		end
	end
end
sgs.ai_card_intention["crXianLingKCard"] = function(self, card, from, tos)
	for _,to in ipairs(tos) do
		if to:getCardCount(true) == 1 then
			if to:getArmor() and self:needToThrowArmor(to) then
				continue
			elseif to:getHandcardNum() == 1 and self:needKongcheng(to) then
				continue
			end
		end
		sgs.updateIntention(from, to, 49)
	end
end
sgs.ai_choicemade_filter["skillChoice"].crXianLing = function(self, player, promptlist)
	local data = player:getTag("crXianLingLTarget")
	local target = data:toPlayer()
	if target then
		local choice = promptlist[#promptlist]
		local bad_skills = "benghuai|wumou|shiyong|yaowu|zaoyao|chanyuan|chouhai"
		local ignore_skills = "wuyan|noswuyan|wenjiu|yuwen|tongji|huoshou|jinjiu"
		if string.match(bad_skills, choice) then
			sgs.updateIntention(player, target, -80)
		elseif string.match(ignore_skills, choice) then
		else
			sgs.updateIntention(player, target, 80)
		end
	end
end
--[[
	技能：水碧
	描述：你攻击范围内的一名其他角色濒死时，若你的武将牌正面朝上，你可以令该角色获得一枚“水碧”标记，然后你翻面并失去2点体力，令该角色回复所有体力。
		锁定技，杀死你的角色获得技能“水寒”。
		你死亡时，你可以指定一名拥有“水碧”标记的角色，该角色增加1点体力上限、回复1点体力并摸一张牌，然后其获得技能“梦归”。
]]--
--source:askForSkillInvoke("crShuiBi", data)
sgs.ai_skill_invoke["crShuiBi"] = function(self, data)
	local dying = data:toDying()
	local victim = dying.who
	local save = false
	local save_lord = false
	if self:isFriend(victim) then
		save = true
	elseif self.role == "renegade" and self.room:alivePlayerCount() > 2 then
		if victim:isLord() then
			save = true
			save_lord = true
		end
	end
	if save then
		local hp = victim:getHp()
		local peach = self:getAllPeachNum(victim)
		if hp + peach >= 1 then
			return false
		end
		if save_lord then
			return true
		end
		local myhp = self.player:getHp()
		local mypeach = self:getAllPeachNum()
		if myhp + mypeach - 2 >= 1 then
			return true
		end
		if self.role == "renegade" then
			return false
		end
		local recover = victim:getMaxHp() - hp
		if recover > 2 then
			return true
		end
		local compare = {self.player, victim}
		self:sort(compare, "threat")
		if compare[1]:objectName() == victim:objectName() then
			return true
		end
	end
	return false
end
--room:askForPlayerChosen(player, targets, "crShuiBi", "@crShuiBi", true)
sgs.ai_skill_playerchosen["crShuiBi"] = function(self, targets)
	local friends = {}
	for _,friend in sgs.qlist(targets) do
		if self:isFriend(friend) then
			table.insert(friends, friend)
		end
	end
	if #friends > 0 then
		self:sort(friends, "defense")
		local maxNum, maxTarget = -1, nil
		for _,friend in ipairs(friends) do
			local num = friend:getMark("@crShuiBiMark")
			if num > maxNum then
				maxNum = num
				maxTarget = friend
			end
		end
		if maxTarget then
			return maxTarget
		end
	end
end
--相关信息
sgs.ai_choicemade_filter["skillInvoke"].crShuiBi = function(self, player, promptlist)
	local choice = promptlist[#promptlist]
	if choice == "yes" then
		local target = self.room:getCurrentDyingPlayer()
		if target then
			sgs.updateIntention(player, target, -200)
		end
	end
end
--[[
	技能：水寒（锁定技）
	描述：准备阶段开始时，你须弃置一张方块牌，否则你失去1点体力。
]]--
--room:askForCard(player, ".|diamond", "@crShuiHan", sgs.QVariant(), sgs.Card_MethodDiscard, nil, false, "crShuiHan", true)
sgs.ai_skill_cardask["@crShuiHan"] = function(self, data, pattern, target, target2, arg, arg2)
	if self.player:getHp() > getBestHp(self.player) then
		return "."
	elseif self:needToLoseHp() then
		return "."
	end
end
--[[
	技能：梦归
	描述：你即将受到伤害时，你可以弃一枚“水碧”标记并摸两张牌，防止此伤害。
]]--
--victim:askForSkillInvoke("crMengGui", data)
sgs.ai_skill_invoke["crMengGui"] = function(self, data)
	local damage = data:toDamage()
	local count = damage.damage
	local hp = self.player:getHp()
	if hp <= count then
		if hp + self:getAllPeachNum() <= count then
			return true
		end
	end
	if count >= 2 then
		if self.player:getMark("@crShuiBiMark") > 1 then
			return true
		elseif math.random(1, 100) <= 50 then
			return true
		end
	end
	return false
end
--[[****************************************************************
	编号：CCC - 07
	武将：南华老仙（隐藏武将）
	称号：黄天的指引者
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
--[[
	技能：移魂（阶段技）
	描述：你可以指定两名体力不同的其他角色，交换他们的体力牌。若这两名角色的体力值之差大于1，你回复1点体力。
]]--
--YiHunCard:Play
local yihun_skill = {
	name = "crYiHun",
	getTurnUseCard = function(self, inclusive)
		if self.room:alivePlayerCount() == 2 then
			return nil
		elseif self.player:hasUsed("#crYiHunCard") then
			return nil
		end
		return sgs.Card_Parse("#crYiHunCard:.:")
	end,
}
table.insert(sgs.ai_skills, yihun_skill)
sgs.ai_skill_use_func["#crYiHunCard"] = function(card, use, self)
	local friends, enemies = {}, {}
	local others = self.room:getOtherPlayers(self.player)
	for _,p in sgs.qlist(others) do
		if self:isFriend(p) then
			table.insert(friends, p)
		else
			table.insert(enemies, p)
		end
	end
	if #friends == 0 or #enemies == 0 then
		return 
	end
	self:sort(friends, "hp")
	self:sort(enemies, "hp")
	enemies = sgs.reverse(enemies)
	for _,friend in ipairs(friends) do
		local hpA = friend:getHp()
		local maxhpA = friend:getMaxHp()
		for _,enemy in ipairs(enemies) do
			if enemy:objectName() ~= friend:objectName() then
				local hpB = enemy:getHp() 
				local maxhpB = enemy:getHp()
				if hpA < hpB and maxhpA <= maxhpB then
					use.card = card
					if use.to then
						use.to:append(friend)
						use.to:append(enemy)
					end
					return 
				end
			end
		end
	end
end
--相关信息
sgs.ai_card_intention["crYiHunCard"] = function(self, card, from, tos)
	if #tos == 2 then
		targetA, targetB = tos[1], tos[2]
		local hpA, hpB = targetA:getHp(), targetB:getHp()
		local maxhpA, maxhpB = targetA:getMaxHp(), targetB:getMaxHp()
		if hpA < hpB and maxhpA <= maxhpB then
		elseif hpA > hpB and maxhpA >= maxhpB then
			targetA, targetB = targetB, targetA
		else
			targetA, targetB = nil, nil
		end
		if targetA and targetB then
			local roleA = sgs.evaluatePlayerRole(targetA)
			local roleB = sgs.evaluatePlayerRole(targetB)
			if roleA == "neutral" and roleB ~= "neutral" then
				sgs.updateIntention(from, targetB, 50)
			elseif roleB == "neutral" and roleA ~= "neutral" then
				sgs.updateIntention(from, targetA, -50)
			elseif roleA == "neutral" and roleB == "neutral" then
				sgs.updateIntention(from, targetA, -50)
				sgs.updateIntention(from, targetB, 50)
			else
				sgs.updateIntention(from, targetA, -50)
			end
		end
	end
end
--[[
	技能：出世（锁定技）
	描述：你即将受到伤害时，你防止此伤害并失去1点体力。
]]--
--[[
	技能：噬魂
	描述：当你进入濒死状态时，若你的武将牌正面朝上，你可以选择一名角色并将你的武将牌翻面，你回复X点体力，然后该角色失去Y点体力。（X为该角色的体力值，Y为你的体力上限与X之间的较大者）
]]--
--room:askForPlayerChosen(player, alives, "crShiHun", "@crShiHun", true, true)
sgs.ai_skill_playerchosen["crShiHun"] = function(self, targets)
	local enemies, unknowns = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			table.insert(enemies, p)
		elseif not self:isFriend(p) then
			table.insert(unknowns, p)
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		return enemies[1]
	end 
	if #unknowns > 0 then
		self:sort(unknowns, "threat")
		return unknowns[1]
	end
end
--相关信息
sgs.ai_playerchosen_intention["crShiHun"] = 200
--[[****************************************************************
	编号：CCC - 08
	武将：掀桌于吉（隐藏武将）
	称号：有无相生
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
sgs.object_name = {
	Slash = "slash",
	Jink = "jink",
	Peach = "peach",
	Analeptic = "analeptic",
	FireSlash = "fire_slash",
	ThunderSlash = "thunder_slash",
	Nullification = "nullification",
	GodSalvation = "god_salvation",
	AmazingGrace = "amazing_grace",
	SavageAssault = "savage_assault",
	ArcheryAttack = "archery_attack",
	IronChain = "iron_chain",
	Collateral = "collateral",
	Duel = "duel",
	FireAttack = "fire_attack",
	Snatch = "snatch",
	Dismantlement = "dismantlement",
	ExNihilo = "ex_nihilo",
	Indulgence = "indulgence",
	SupplyShortage = "supply_shortage",
	Lightning = "lightning",
	Volcano = "volcano",
	Mudslide = "mudslide",
	Earthquake = "earthquake",
	Typhoon = "typhoon",
	Deluge = "deluge",
}
function cn2on(class_name, default_value)
	return sgs.object_name[class_name] or default_value
end
--[[
	技能：幻惑
	描述：当你需要使用或打出一张基本牌或非延时性锦囊牌时，你可以视为使用或打出了该牌。 
]]--
--room:askForChoice(user, "crHuanHuo", choices, sgs.QVariant(is_use))
sgs.ai_skill_choice["crHuanHuo"] = function(self, choices, data)
	local names = choices:split("+")
	local is_use = data:toBool()
	if is_use then
		while #names > 0 do
			local index = math.random(1, #names)
			local name = names[index]
			local to_use = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
			to_use:deleteLater()
			local dummy_use = {
				isDummy = true,
				to = sgs.SPlayerList(),
			}
			if to_use:isKindOf("BasicCard") then
				self:useBasicCard(to_use, dummy_use)
			elseif to_use:isKindOf("TrickCard") then
				self:useTrickCard(to_use, dummy_use)
			end
			if name == "iron_chain" and dummy_use.to:isEmpty() then
				dummy_use.card = nil
			end
			if dummy_use.card and dummy_use.card:objectName() == name then
				return name
			end
			table.remove(names, index)
		end
	end
	if #names > 1 then
		return names[math.random(1, #names)]
	end
	return names[1]
end
--room:askForUseCard(user, "@@crHuanHuo", prompt)
--room:askForChoice(user, "crHuanHuo", choices)
--room:askForUseCard(user, "@@crHuanHuo", prompt)
sgs.ai_skill_use["@@crHuanHuo"] = function(self, prompt, method)
	local name = prompt:split(":")[4]
	if name then
		local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
		card:deleteLater()
		local dummy_use = {
			isDummy = true,
			to = sgs.SPlayerList(),
		}
		if card:isKindOf("BasicCard") then
			self:useBasicCard(card, dummy_use)
		elseif card:isKindOf("TrickCard") then
			self:useTrickCard(card, dummy_use)
		end
		if not dummy_use.card then
			return "."
		elseif dummy_use.to:isEmpty() then
			return "."
		end
		local targets = {}
		for _,target in sgs.qlist(dummy_use.to) do
			table.insert(targets, target:objectName())
		end
		local card_str = "#crHuanHuoSelectCard:.:->"..table.concat(targets, "+")
		return card_str
	end
	return "."
end
--HuanHuoCard:Play
local huanhuo_skill = {
	name = "crHuanHuo",
	getTurnUseCard = function(self, inclusive)
		local n = self.player:usedTimes("#crHuanHuoCard")
		if n == 0 then
			return sgs.Card_Parse("#crHuanHuoCard:.:")
		elseif n > 4 then
			return nil
		elseif math.random(1, 100) < 48 / n then
			return sgs.Card_Parse("#crHuanHuoCard:.:")
		end
	end,
}
table.insert(sgs.ai_skills, huanhuo_skill)
sgs.ai_skill_use_func["#crHuanHuoCard"] = function(card, use, self)
	use.card = card
end
--HuanHuoCard:Response
sgs.ai_cardsview["crHuanHuo"] = function(self, class_name, player)
	if math.random(1, 100) > 60 then
		return nil
	end
	local name = cn2on(class_name)
	if name then
		return "#crHuanHuoCard:.:"..name
	end
end
--相关信息
sgs.ai_use_priority["crHuanHuoCard"] = 4
sgs.ai_use_value["crHuanHuoCard"] = 4
--[[
	技能：掀桌（限定技）
	描述：出牌阶段，你可以令所有其他角色弃置所有手牌和装备并失去1点体力上限，然后你立即死亡。
]]--
--XianZhuoCard:Play
local xianzhuo_skill = {
	name = "crXianZhuo",
	getTurnUseCard = function(self, inclusive)
		return sgs.Card_Parse("#crXianZhuoCard:.:")
	end,
}
table.insert(sgs.ai_skills, xianzhuo_skill)
sgs.ai_skill_use_func["#crXianZhuoCard"] = function(card, use, self)
	if use.isDummy then
		use.card = card
	elseif math.random(1, 100) <= 30 then
		use.card = card
	end
end