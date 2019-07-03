--[[
	太阳神三国杀武将扩展包·经典再临
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
module("extensions.classic", package.seeall)
extension = sgs.Package("classic", sgs.Package_GeneralPack)
--技能暗将
AnJiang = sgs.General(extension, "crAnJiang", "god", 5, true, true, true)
--翻译信息
sgs.LoadTranslationTable{
	["classic"] = "经典再临",
}
--[[****************************************************************
	编号：CCC - 01
	武将：神将徐元直
	称号：神将强辅
	势力：蜀
	性别：男
	体力上限：4勾玉
]]--****************************************************************
XuYuanZhi = sgs.General(extension, "crXuYuanZhi", "shu", 4)
--翻译信息
sgs.LoadTranslationTable{
	["crXuYuanZhi"] = "神将徐元直",
	["&crXuYuanZhi"] = "徐元直",
	["#crXuYuanZhi"] = "神将强辅",
	["designer:crXuYuanZhi"] = "DGAH",
	["cv:crXuYuanZhi"] = "官方",
	["illustrator:crXuYuanZhi"] = "XINA",
	["~crXuYuanZhi"] = "娘……孩儿不孝……向您……请罪……",
}
--[[
	技能：强举（阶段技）
	描述：你可以弃置至少一张手牌并指定一名角色，你选择一项：1、该角色摸等量的牌；2、该角色获得等量合理的标记。
]]--
function getQiangJuChoices(room, source, target, count)
	local single = ( count == 1 )
	local choices = {}
	--@arise（“雄异”标记，来自技能“雄异”）
	if target:hasSkill("xiongyi") then
		table.insert(choices, "@arise")
	end
	--@bear（“忍”标记，来自技能“忍戒”）
	if target:hasSkill("renjie") then
		table.insert(choices, "@bear")
	end
	--@benxi（“奔袭”标记，来自技能“奔袭”）
	if target:hasSkill("benxi") and target:getPhase() == sgs.Player_Play then
		table.insert(choices, "@benxi")
	end
	--@bossExp（“经验”标记，来自闯关模式）
	--@burn（“焚城”标记，来自技能“焚城”）
	if target:hasSkill("fencheng") then
		table.insert(choices, "@burn")
	end
	--@burnheart（“焚心”标记，来自技能“焚心”）
	if target:hasSkill("fenxin") then
		table.insert(choices, "@burnheart")
	end
	--@chanyuan（“缠怨”标记，来自技能“缠怨”）
	--@chaos（“乱武”标记，来自技能“乱武”）
	if target:hasSkill("luanwu") then
		table.insert(choices, "@chaos")
	end
	--@chuanxin（“穿心”标记，来自技能“穿心”）
	--@collapse（“崩坏”标记，来自技能“毒士”）
	--@conspiracy（“共谋”标记，来自技能“共谋”）
	--@defense（“守”标记，来自技能“镇卫”）
	local alives = room:getAlivePlayers()
	if single and target:getMark("@defense") == 0 then
		for _,p in sgs.qlist(alives) do
			if p:hasSkill("zhenwei") then
				table.insert(choices, "@defense")
				break
			end
		end
	end
	--@duanchang（“断肠”标记，来自技能“断肠”）
	--@earth（“五灵·土”标记，来自技能“五灵”）
	--@fenwei（“奋威”标记，来自技能“奋威”）
	if target:hasSkill("fenwei") then
		table.insert(choices, "@fenwei")
	end
	--@fenyong（“愤勇”标记，来自技能“愤勇”）
	if single and target:getMark("@fenyong") == 0 then
		if target:hasSkill("fenyong") then
			table.insert(choices, "@fenyong")
		end
	end
	--@fight（“战”标记，来自技能“”）
	--@fire（“五灵·火”标记，来自技能“五灵”）
	--@flame（“业炎”标记，来自技能“业炎”）
	if target:hasSkill("yeyan") then
		table.insert(choices, "@flame")
	end
	--@fog（“大雾”标记，来自技能“大雾”）
	if single and target:getMark("@fog") == 0 then
		for _,p in sgs.qlist(alives) do
			if p:hasSkill("dawu") then
				table.insert(choices, "@fog") 
				break
			end
		end
	end
	--@frantic（“暴走”标记，来自）
	--@gale（“狂风”标记，来自技能“狂风”）
	if single and target:getMark("@gale") == 0 then
		for _,p in sgs.qlist(alives) do
			if p:hasSkill("kuangfeng") then
				table.insert(choices, "@gale")
				break
			end
		end
	end
	--@handover（“献州”标记，来自技能“献州”）
	if target:hasSkill("xianzhou") then
		table.insert(choices, "@handover")
	end
	--@hate（“誓”标记，来自技能“誓仇”）
	--@hate_to（“仇”标记，来自技能“誓仇”）
	--@hengjiang（“横江”标记，来自技能“横江”）
	for _,p in sgs.qlist(alives) do
		if p:hasSkill("hengjiang") and p:objectName() ~= target:objectName() then
			table.insert(choices, "@hengjiang")
			break
		end
	end
	--@huashen（“化身”标记，来自技能“化身”）
	--@jilei_basic（“鸡肋·基本牌”标记，来自技能“鸡肋”）
	--@jilei_equip（“鸡肋·装备牌”标记，来自技能“鸡肋”）
	--@jilei_trick（“鸡肋·锦囊牌”标记，来自技能“鸡肋”）
	--@kuiwei（“溃围”标记，来自技能“溃围”）
	if single and target:getMark("@kuiwei") == 0 then
		if target:hasSkill("kuiwei") then
			table.insert(choices, "@kuiwei")
		end
	end
	--@laoji（“老骥”标记，来自技能“伏枥”）
	if target:hasSkill("fuli") then
		table.insert(choices, "@laoji")
	end
	--@late（“迟”标记，来自技能“智迟”）
	if single and target:getMark("@late") == 0 then
		if target:hasSkill("zhichi") then
			table.insert(choices, "@late")
		end
	end
	--@loyal（“忠”标记，来自技能“忠义”）
	if target:hasSkill("zhongyi") then
		table.insert(choices, "@loyal")
	end
	--@luoyi（“裸衣”标记，来自技能“裸衣”）
	if single and target:getMark("@luoyi") == 0 then
		if target:hasSkill("luoyi") then
			table.insert(choices, "@luoyi")
		end
	end
	--@nightmare（“梦魇”标记，来自技能“武魂”）
	for _,p in sgs.qlist(alives) do
		if p:hasSkill("wuhun") and p:objectName() ~= target:objectName() then
			table.insert(choices, "@nightmare")
		end
	end
	--@nirvana（“涅槃”标记，来自技能“涅槃”）
	if target:hasSkill("niepan") then
		table.insert(choices, "@nirvana")
	end
	--@nosburn（“焚”标记，来自技能“焚城”）
	if target:hasSkill("nosfencheng") then
		table.insert(choices, "@nosburn")
	end
	--@qianxi_black（“潜袭·黑色”标记，来自技能“潜袭”）
	--@qianxi_red（“潜袭·红色”标记，来自技能“潜袭”）
	--@rescue（“解烦”标记，来自技能“解烦”）
	if target:hasSkill("jiefan") then
		table.insert(choices, "@rescue")
	end
	--@round（“退治”标记，来自僵尸模式）
	--@shouye（“授业”标记，来自技能“授业”）
	if target:hasSkill("shouye") and target:getMark("shien") == 0 then
		table.insert(choices, "@shouye")
	end
	--@skill_invalidity（“技能无效”标记，来自技能“义绝”）
	--@sleep（“梦”标记，来自技能“醉乡”）
	if target:hasSkill("zuixiang") then
		table.insert(choices, "@sleep")
	end
	--@songci（“颂词”标记，来自技能“颂词”）
	if single and target:getMark("@songci") == 0 then
		for _,p in sgs.qlist(alives) do
			if p:hasSkill("songci") then
				table.insert(choices, "@songci")
				break
			end
		end
	end
	--@struggle（“死战”标记，来自技能“死战”）
	if target:hasSkill("sizhan") then
		table.insert(choices, "@struggle")
	end
	--@substitute（“替身”标记，来自技能“替身”）
	if target:hasSkill("tishen") then
		table.insert(choices, "@substitute")
	end
	--@substitute_hp（“替身·体力”标记，来自技能“替身”）
	if target:hasSkill("tishen") then
		table.insert(choices, "@substitute_hp")
	end
	--@thunder（“五灵·雷”标记，来自技能“五灵”）
	--@tied（“连理”标记，来自技能“连理”）
	--@twine（“挟缠”标记，来自技能“挟缠”）
	if target:hasSkill("xiechan") then
		table.insert(choices, "@twine")
	end
	--@waked（“觉醒”标记）
	--@water（“五灵·水”标记，来自技能“五灵”）
	--@wen（“文”标记，来自技能“谋断”）
	--@wind（“五灵·风”标记，来自技能“五灵”）
	--@wrath（“暴怒”标记，来自技能“狂暴”）
	if target:hasSkill("kuangbao") then
		table.insert(choices, "@wrath")
	end
	--@wu（“武”标记，来自技能“谋断”）
	--@xiemu_qun（“协穆·群”标记，来自技能“协穆”）
	if single and target:getMark("@xiemu_qun") == 0 then
		if target:hasSkill("xiemu") then
			table.insert(choices, "@xiemu_qun")
		end
	end
	--@xiemu_shu（“协穆·蜀”标记，来自技能“协穆”）
	if single and target:getMark("@xiemu_shu") == 0 then
		if target:hasSkill("xiemu") then
			table.insert(choices, "@xiemu_shu")
		end
	end
	--@xiemu_wei（“协穆·魏”标记，来自技能“协穆”）
	if single and target:getMark("@xiemu_wei") == 0 then
		if target:hasSkill("xiemu") then
			table.insert(choices, "@xiemu_wei")
		end
	end
	--@xiemu_wu（“协穆·吴”标记，来自技能“协穆”）
	if single and target:getMark("@xiemu_wu") == 0 then
		if target:hasSkill("xiemu") then
			table.insert(choices, "@xiemu_wu")
		end
	end
	--摸牌
	table.insert(choices, "draw")
	return table.concat(choices, "+")
end
QiangJuCard = sgs.CreateSkillCard{
	name = "crQiangJuCard",
	--skill_name = "crQiangJu",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		local target = targets[1]
		local count = self:subcardsLength()
		local choices = getQiangJuChoices(room, source, target, count)
		local ai_data = sgs.QVariant()
		ai_data:setValue(target)
		source:setTag("crQiangJuTarget", ai_data) --For AI
		local choice = room:askForChoice(source, "crQiangJu", choices, ai_data)
		source:removeTag("crQiangJuTarget") --For AI
		if choice == "draw" then
			if target:objectName() == source:objectName() then
				room:broadcastSkillInvoke("crQiangJu", 3) --播放配音
			else
				room:broadcastSkillInvoke("crQiangJu", 1) --播放配音
			end
			room:drawCards(target, count, "crQiangJu")
		else
			room:broadcastSkillInvoke("crQiangJu", 2) --播放配音
			target:gainMark(choice, count)
		end
	end,
}
QiangJu = sgs.CreateViewAsSkill{
	name = "crQiangJu",
	n = 999,
	view_filter = function(self, selected, to_select)
		return not to_select:isEquipped()
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = QiangJuCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		if player:isKongcheng() then
			return false
		elseif player:hasUsed("#crQiangJuCard") then
			return false
		end
		return true
	end,
}
--添加技能
XuYuanZhi:addSkill(QiangJu)
--翻译信息
sgs.LoadTranslationTable{
	["crQiangJu"] = "强举",
	[":crQiangJu"] = "<font color=\"green\"><b>阶段技</b></font>，你可以弃置至少一张手牌并指定一名角色，你选择一项：1、该角色摸等量的牌；2、该角色获得等量合理的标记。",
	["$crQiangJu1"] = "将军岂愿抓牌乎？",
	["$crQiangJu2"] = "天下大任，望君莫辞！",
	["$crQiangJu3"] = "容我三思。",
	["crqiangju"] = "强举",
}
--[[
	技能：无语
	描述：结束阶段开始时，若你于本回合内未造成过伤害，你可以一项：1、弃置场上一枚合理的标记；2、摸两张牌。
]]--
function getWuYuChoices(room, source, target)
	local choices = {}
	--@arise（“雄异”标记，来自技能“雄异”）
	if target:getMark("@arise") > 0 then
		table.insert(choices, "@arise")
	end
	--@bear（“忍”标记，来自技能“忍戒”）
	if target:getMark("@bear") > 0 then
		table.insert(choices, "@bear")
	end
	--@benxi（“奔袭”标记，来自技能“奔袭”）
	--@bossExp（“经验”标记，来自闯关模式）
	--@burn（“焚城”标记，来自技能“焚城”）
	if target:getMark("@burn") > 0 then
		table.insert(choices, "@burn")
	end
	--@burnheart（“焚心”标记，来自技能“焚心”）
	if target:getMark("@burnheart") > 0 then
		table.insert(choices, "@burnheart")
	end
	--@chanyuan（“缠怨”标记，来自技能“缠怨”）
	--@chaos（“乱武”标记，来自技能“乱武”）
	if target:getMark("@chaos") > 0 then
		table.insert(choices, "@chaos")
	end
	--@chuanxin（“穿心”标记，来自技能“穿心”）
	--@collapse（“崩坏”标记，来自技能“毒士”）
	--@conspiracy（“共谋”标记，来自技能“共谋”）
	--@defense（“守”标记，来自技能“镇卫”）
	if target:getMark("@defense") > 0 then
		table.insert(choices, "@defense")
	end
	--@duanchang（“断肠”标记，来自技能“断肠”）
	--@earth（“五灵·土”标记，来自技能“五灵”）
	--@fenwei（“奋威”标记，来自技能“奋威”）
	if target:getMark("@fenwei") > 0 then
		table.insert(choices, "@fenwei")
	end
	--@fenyong（“愤勇”标记，来自技能“愤勇”）
	if target:getMark("@fenyong") > 0 then
		table.insert(choices, "@fenyong")
	end
	--@fight（“战”标记，来自技能“”）
	--@fire（“五灵·火”标记，来自技能“五灵”）
	--@flame（“业炎”标记，来自技能“业炎”）
	if target:getMark("@flame") > 0 then
		table.insert(choices, "@flame")
	end
	--@fog（“大雾”标记，来自技能“大雾”）
	if target:getMark("@fog") > 0 then
		table.insert(choices, "@fog") 
	end
	--@frantic（“暴走”标记，来自）
	--@gale（“狂风”标记，来自技能“狂风”）
	if target:getMark("@gale") > 0 then
		table.insert(choices, "@gale")
	end
	--@handover（“献州”标记，来自技能“献州”）
	if target:getMark("@handover") > 0 then
		table.insert(choices, "@handover")
	end
	--@hate（“誓”标记，来自技能“誓仇”）
	--@hate_to（“仇”标记，来自技能“誓仇”）
	--@hengjiang（“横江”标记，来自技能“横江”）
	if target:getMark("@hengjiang") > 0 then
		table.insert(choices, "@hengjiang")
	end
	--@huashen（“化身”标记，来自技能“化身”）
	--@jilei_basic（“鸡肋·基本牌”标记，来自技能“鸡肋”）
	--@jilei_equip（“鸡肋·装备牌”标记，来自技能“鸡肋”）
	--@jilei_trick（“鸡肋·锦囊牌”标记，来自技能“鸡肋”）
	--@kuiwei（“溃围”标记，来自技能“溃围”）
	if target:getMark("@kuiwei") > 0 then
		table.insert(choices, "@kuiwei")
	end
	--@laoji（“老骥”标记，来自技能“伏枥”）
	if target:getMark("@laoji") > 0 then
		table.insert(choices, "@laoji")
	end
	--@late（“迟”标记，来自技能“智迟”）
	if target:getMark("@late") > 0 then
		table.insert(choices, "@late")
	end
	--@loyal（“忠”标记，来自技能“忠义”）
	if target:getMark("@loyal") > 0 then
		table.insert(choices, "@loyal")
	end
	--@luoyi（“裸衣”标记，来自技能“裸衣”）
	if target:getMark("@luoyi") > 0 then
		table.insert(choices, "@luoyi")
	end
	--@nightmare（“梦魇”标记，来自技能“武魂”）
	if target:getMark("@nightmare") > 0 then
		table.insert(choices, "@nightmare")
	end
	--@nirvana（“涅槃”标记，来自技能“涅槃”）
	if target:getMark("@nirvana") > 0 then
		table.insert(choices, "@nirvana")
	end
	--@nosburn（“焚”标记，来自技能“焚城”）
	if target:getMark("@nosburn") > 0 then
		table.insert(choices, "@nosburn")
	end
	--@qianxi_black（“潜袭·黑色”标记，来自技能“潜袭”）
	--@qianxi_red（“潜袭·红色”标记，来自技能“潜袭”）
	--@rescue（“解烦”标记，来自技能“解烦”）
	if target:getMark("@rescue") > 0 then
		table.insert(choices, "@rescue")
	end
	--@round（“退治”标记，来自僵尸模式）
	--@shouye（“授业”标记，来自技能“授业”）
	if target:getMark("@shouye") > 0 then
		table.insert(choices, "@shouye")
	end
	--@skill_invalidity（“技能无效”标记，来自技能“义绝”）
	--@sleep（“梦”标记，来自技能“醉乡”）
	if target:getMark("@sleep") > 0 then
		table.insert(choices, "@sleep")
	end
	--@songci（“颂词”标记，来自技能“颂词”）
	if target:getMark("@songci") > 0 then
		table.insert(choices, "@songci")
	end
	--@struggle（“死战”标记，来自技能“死战”）
	if target:getMark("@struggle") > 0 then
		table.insert(choices, "@struggle")
	end
	--@substitute（“替身”标记，来自技能“替身”）
	if target:getMark("@substitute") > 0 then
		table.insert(choices, "@substitute")
	end
	--@substitute_hp（“替身·体力”标记，来自技能“替身”）
	if target:getMark("@substitute_hp") > 0 then
		table.insert(choices, "@substitute_hp")
	end
	--@thunder（“五灵·雷”标记，来自技能“五灵”）
	--@tied（“连理”标记，来自技能“连理”）
	--@twine（“挟缠”标记，来自技能“挟缠”）
	if target:getMark("@twine") > 0 then
		table.insert(choices, "@twine")
	end
	--@waked（“觉醒”标记）
	--@water（“五灵·水”标记，来自技能“五灵”）
	--@wen（“文”标记，来自技能“谋断”）
	--@wind（“五灵·风”标记，来自技能“五灵”）
	--@wrath（“暴怒”标记，来自技能“狂暴”）
	if target:getMark("@wrath") > 0 then
		table.insert(choices, "@wrath")
	end
	--@wu（“武”标记，来自技能“谋断”）
	--@xiemu_qun（“协穆·群”标记，来自技能“协穆”）
	if target:getMark("@xiemu_qun") > 0 then
		table.insert(choices, "@xiemu_qun")
	end
	--@xiemu_shu（“协穆·蜀”标记，来自技能“协穆”）
	if target:getMark("@xiemu_shu") > 0 then
		table.insert(choices, "@xiemu_shu")
	end
	--@xiemu_wei（“协穆·魏”标记，来自技能“协穆”）
	if target:getMark("@xiemu_wei") > 0 then
		table.insert(choices, "@xiemu_wei")
	end
	--@xiemu_wu（“协穆·吴”标记，来自技能“协穆”）
	if target:getMark("@xiemu_wu") > 0 then
		table.insert(choices, "@xiemu_wu")
	end
	--取消
	table.insert(choices, "cancel")
	return choices
end
WuYu = sgs.CreateTriggerSkill{
	name = "crWuYu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart, sgs.Damage},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.EventPhaseStart then
			local phase = player:getPhase()
			if phase == sgs.Player_Finish then
				if player:getMark("crWuYuDamage") == 0 then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						local choices = getWuYuChoices(room, player, p)
						if #choices > 1 then
							targets:append(p)
						end
					end
					if not targets:isEmpty() then
						local target = room:askForPlayerChosen(player, targets, "crWuYu", "@crWuYu", true)
						if target then
							local choices = getWuYuChoices(room, player, target)
							choices = table.concat(choices, "+")
							local ai_data = sgs.QVariant()
							ai_data:setValue(target)
							player:setTag("crWuYuTarget", ai_data) --For AI
							local choice = room:askForChoice(player, "crWuYu", choices, ai_data)
							player:removeTag("crWuYuTarget")
							if choice ~= "cancel" then
								room:broadcastSkillInvoke("crWuYu", 1) --播放配音
								target:loseMark(choice, 1)
								return false
							end
						end
					end
					if player:askForSkillInvoke("crWuYu-draw", data) then
						room:broadcastSkillInvoke("crWuYu", 2) --播放配音
						room:drawCards(player, 2, "crWuYu")
					end
				else
					room:setPlayerMark(player, "crWuYuDamage", 0)
				end
			elseif phase == sgs.Player_NotActive then
				room:setPlayerMark(player, "crWuYuDamage", 0)
			end
		elseif event == sgs.Damage then
			if player:getMark("crWuYuDamage") > 0 then
				return false
			elseif player:getPhase() == sgs.Player_NotActive then
				return false
			end
			local damage = data:toDamage()
			local source = damage.from
			if source and source:objectName() == player:objectName() then
				room:setPlayerMark(player, "crWuYuDamage", 1)
			end
		end
		return false
	end,
}
--添加技能
XuYuanZhi:addSkill(WuYu)
--翻译信息
sgs.LoadTranslationTable{
	["crWuYu"] = "无语",
	[":crWuYu"] = "结束阶段开始时，若你于本回合内未造成过伤害，你可以一项：1、弃置场上一枚合理的标记；2、摸两张牌。",
	["$crWuYu1"] = "韬光养晦，静待时机……",
	["$crWuYu2"] = "嘘！言多必失啊……",
	["@crWuYu"] = "无语：您可以选择一名角色，弃置其一枚合理的标记",
	["crWuYu-draw"] = "无语·摸牌",
}
--[[****************************************************************
	编号：CCC - 02
	武将：夏侯杰
	称号：套马的汉子
	势力：魏
	性别：男
	体力上限：3勾玉
]]--****************************************************************
XiaHouJie = sgs.General(extension, "crXiaHouJie", "wei", 3)
--翻译信息
sgs.LoadTranslationTable{
	["crXiaHouJie"] = "夏侯杰",
	["&crXiaHouJie"] = "夏侯杰",
	["#crXiaHouJie"] = "套马的汉子",
	["designer:crXiaHouJie"] = "宇文天启",
	["cv:crXiaHouJie"] = "庞小鸡",
	["illustrator:crXiaHouJie"] = "小浣熊",
	["~crXiaHouJie"] = "编剧！这不公平！",
}
--[[
	技能：吓尿（锁定技）
	描述：一名其他角色造成伤害时，若你在其攻击范围内，你弃置所有手牌并摸X张牌（X为该角色的体力）。
]]--
XiaNiao = sgs.CreateTriggerSkill{
	name = "crXiaNiao",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damage},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local source = damage.from
		if source and source:objectName() then
			local room = player:getRoom()
			local others = room:getOtherPlayers(player)
			local hp = player:getHp()
			for _,p in sgs.qlist(others) do
				if p:hasSkill("crXiaNiao") then
					if player:inMyAttackRange(p) then
						room:broadcastSkillInvoke("crXiaNiao") --播放配音
						room:notifySkillInvoked(p, "crXiaNiao") --显示技能发动
						p:throwAllHandCards()
						room:drawCards(p, hp, "crXiaNiao")
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target and target:isAlive()
	end,
}
--添加技能
XiaHouJie:addSkill(XiaNiao)
--翻译信息
sgs.LoadTranslationTable{
	["crXiaNiao"] = "吓尿",
	[":crXiaNiao"] = "<font color=\"blue\"><b>锁定技</b></font>，一名其他角色造成伤害时，若你在其攻击范围内，你弃置所有手牌并摸X张牌（X为该角色的体力）。",
	["$crXiaNiao"] = "哎呀妈呀~~吓死爹啦！",
}
--[[
	技能：躺枪（锁定技）
	描述：杀死你的角色失去1点体力上限并获得技能“躺枪”。
]]--
TangQiang = sgs.CreateTriggerSkill{
	name = "crTangQiang",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Death},
	on_trigger = function(self, event, player, data)
		local death = data:toDeath()
		local victim = death.who
		if victim and victim:objectName() == player:objectName() then
			local reason = death.damage
			if reason then
				local source = reason.from
				if source and source:isAlive() then
					local room = player:getRoom()
					room:broadcastSkillInvoke("crTangQiang") --播放配音
					room:notifySkillInvoked(player, "crTangQiang") --显示技能发动
					room:loseMaxHp(source, 1)
					if source:isAlive() then
						room:handleAcquireDetachSkills(source, "crTangQiang")
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target and target:hasSkill("crTangQiang")
	end,
}
--添加技能
XiaHouJie:addSkill(TangQiang)
--翻译信息
sgs.LoadTranslationTable{
	["crTangQiang"] = "躺枪",
	[":crTangQiang"] = "<font color=\"blue\"><b>锁定技</b></font>，杀死你的角色失去1点体力上限并获得技能“躺枪”。",
	["$crTangQiang"] = "不是吧？躺着也中枪？！",
}
--[[****************************************************************
	编号：CCC - 03
	武将：钟会
	称号：桀骜的野心家
	势力：魏
	性别：男
	体力上限：3勾玉
]]--****************************************************************
ZhongHui = sgs.General(extension, "crZhongHui", "wei", 3)
--翻译信息
sgs.LoadTranslationTable{
	["crZhongHui"] = "钟会",
	["&crZhongHui"] = "钟会",
	["#crZhongHui"] = "桀骜的野心家",
	["designer:crZhongHui"] = "韩旭",
	["cv:crZhongHui"] = "韩旭",
	["illustrator:crZhongHui"] = "雪君S",
	["~crZhongHui"] = "大权在手竟一夕败亡！时耶？命耶？……",
	["$crZhongHuiAnimate"] = "image=image/animate/crZhongHui.png",
}
--[[
	技能：争功
	描述：你受到一次伤害时，你可以将伤害来源装备区中的一张牌置入你的装备区。
]]--
ZhengGong = sgs.CreateTriggerSkill{
	name = "crZhengGong",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local source = damage.from
		if source and source:hasEquip() then
			if source:objectName() == player:objectName() then
				return false
			end
			if player:askForSkillInvoke("crZhengGong", data) then
				local room = player:getRoom()
				local id = room:askForCardChosen(player, source, "e", "crZhengGong")
				if id > 0 then
					room:broadcastSkillInvoke("crZhengGong") --播放配音
					room:notifySkillInvoked(player, "crZhengGong") --显示技能发动
					local equip = sgs.Sanguosha:getCard(id)
					local myequip = nil
					if equip:isKindOf("Weapon") then
						myequip = player:getWeapon()
					elseif equip:isKindOf("Armor") then
						myequip = player:getArmor()
					elseif equip:isKindOf("DefensiveHorse") then
						myequip = player:getDefensiveHorse()
					elseif equip:isKindOf("OffensiveHorse") then
						myequip = player:getOffensiveHorse()
					elseif equip:isKindOf("Treasure") then
						myequip = player:getTreasure()
					end
					if myequip then
						room:throwCard(myequip, player)
					end
					local reason = sgs.CardMoveReason(
						sgs.CardMoveReason_S_REASON_PUT, 
						player:objectName(),
						source:objectName(),
						""
					)
					local move = sgs.CardsMoveStruct()
					move.from = source
					move.from_place = sgs.Player_PlaceEquip
					move.to = player
					move.to_place = sgs.Player_PlaceEquip
					move.card_ids:append(id)
					move.reason = reason
					room:moveCardsAtomic(move, true)
				end
			end
		end
		return false
	end,
}
--添加技能
ZhongHui:addSkill(ZhengGong)
--翻译信息
sgs.LoadTranslationTable{
	["crZhengGong"] = "争功",
	[":crZhengGong"] = "你受到一次伤害时，你可以将伤害来源装备区中的一张牌置入你的装备区。",
	["$crZhengGong"] = "夺得军权方能施展一番",
}
--[[
	技能：权计
	描述：其他角色的回合开始前，你可以与其拼点。若你赢，该角色跳过准备阶段和判定阶段。
]]--
QuanJi = sgs.CreateTriggerSkill{
	name = "crQuanJi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart, sgs.EventPhaseChanging},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TurnStart then
			if player:isKongcheng() then
				return false
			end
			local others = room:getOtherPlayers(player)
			local ai_data = sgs.QVariant()
			ai_data:setValue(player)
			for _,source in sgs.qlist(others) do
				if source:hasSkill("crQuanJi") and not source:isKongcheng() then
					if source:askForSkillInvoke("crQuanJi", ai_data) then
						room:broadcastSkillInvoke("crQuanJi") --播放配音
						room:notifySkillInvoked(source, "crQuanJi") --显示技能发动
						local success = source:pindian(player, "crQuanJi")
						if success then
							room:setPlayerMark(player, "crQuanJiEffect", 1)
						end
					end
				end
			end
		elseif event == sgs.EventPhaseChanging then
			if player:getMark("crQuanJiEffect") == 0 then
				return false
			end
			local change = data:toPhaseChange()
			local phase = change.to
			if phase == sgs.Player_Start or phase == sgs.Player_Judge then
				if not player:isSkipped(phase) then
					player:skip(phase)
				end
			elseif phase == sgs.Player_NotActive then
				room:setPlayerMark(player, "crQuanJiEffect", 0)
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target and target:isAlive()
	end,
}
--添加技能
ZhongHui:addSkill(QuanJi)
--翻译信息
sgs.LoadTranslationTable{
	["crQuanJi"] = "权计",
	[":crQuanJi"] = "其他角色的回合开始前，你可以与其拼点。若你赢，该角色跳过准备阶段和判定阶段。",
	["$crQuanJi"] = "终于轮到我掌权了",
}
--[[
	技能：拜将（觉醒技）
	描述：准备阶段开始时，若你装备区的牌为三张或更多时，你增加1点体力上限，失去技能“权计”和“争功”，获得技能“野心”。
]]--
BaiJiang = sgs.CreateTriggerSkill{
	name = "crBaiJiang",
	frequency = sgs.Skill_Wake,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Start then
			local equips = player:getEquips()
			if equips:length() >= 3 then
				local room = player:getRoom()
				room:broadcastSkillInvoke("crBaiJiang") --播放配音
				room:doLightbox("$crZhongHuiAnimate") --显示全屏信息特效
				room:notifySkillInvoked(player, "crBaiJiang") --显示技能发动
				room:setPlayerMark(player, "crBaiJiangWaked", 1)
				local maxhp = player:getMaxHp() + 1
				room:setPlayerProperty(player, "maxhp", sgs.QVariant(maxhp))
				room:handleAcquireDetachSkills(player, "-crQuanJi|-crZhengGong|crYeXin")
				player:gainMark("@waked", 1)
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		if target and target:isAlive() then
			if target:hasSkill("crBaiJiang") then
				return target:getMark("crBaiJiangWaked") == 0
			end
		end
		return false
	end,
}
--添加技能
ZhongHui:addSkill(BaiJiang)
--翻译信息
sgs.LoadTranslationTable{
	["crBaiJiang"] = "拜将",
	[":crBaiJiang"] = "<font color=\"purple\"><b>觉醒技</b></font>，准备阶段开始时，若你装备区的牌为三张或更多时，你增加1点体力上限，失去技能“权计”和“争功”，获得技能“野心”。\
\
★<b>野心</b>: 你造成或受到一次伤害时，你可以将牌堆顶的一张牌置于你的武将牌上，称为“权”。<font color=\"green\"><b>阶段技<b></font>，你可以用至少一张手牌交换等量的“权”。",
	["$crBaiJiang"] = "哈！哈哈哈哈……",
}
--[[
	技能：野心
	描述：你造成或受到一次伤害时，你可以将牌堆顶的一张牌置于你的武将牌上，称为“权”。
		阶段技，你可以用至少一张手牌交换等量的“权”。
]]--
YeXinCard = sgs.CreateSkillCard{
	name = "crYeXinCard",
	--skill_name = "crYeXin",
	target_fixed = true,
	will_throw = false,
	mute = false,
	on_use = function(self, room, source, targets)
		local count = self:subcardsLength()
		source:addToPile("crYeXinPile", self, true)
		local card_ids = source:getPile("crYeXinPile")
		local to_get = sgs.IntList()
		for i=1, count, 1 do
			room:fillAG(card_ids, source)
			local id = room:askForAG(source, card_ids, false, "crYeXin")
			room:clearAG(source)
			if id > 0 then
				to_get:append(id)
				card_ids:removeOne(id)
			end
		end
		local move = sgs.CardsMoveStruct()
		move.card_ids = to_get
		move.to = source
		move.to_place = sgs.Player_PlaceHand
		move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_EXCHANGE_FROM_PILE, source:objectName())
		room:moveCardsAtomic(move, true)
	end,
}
YeXinVS = sgs.CreateViewAsSkill{
	name = "crYeXin",
	n = 999,
	view_filter = function(self, selected, to_select)
		return not to_select:isEquipped()
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = YeXinCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		if player:isKongcheng() then
			return false
		elseif player:getPile("crYeXinPile"):isEmpty() then
			return false
		elseif player:hasUsed("#crYeXinCard") then
			return false
		end
		return true
	end,
}
YeXin = sgs.CreateTriggerSkill{
	name = "crYeXin",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damage, sgs.Damaged},
	view_as_skill = YeXinVS,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		if event == sgs.Damage then
			local source = damage.from
			if source and source:objectName() then
				if player:askForSkillInvoke("crYeXin", data) then
					room:broadcastSkillInvoke("crYeXin") --播放配音
					room:notifySkillInvoked(player, "crYeXin") --显示技能发动
					local id = room:drawCard()
					player:addToPile("crYeXinPile", id, true)
				end
			end
		elseif event == sgs.Damaged then
			local victim = damage.to
			if victim and victim:objectName() then
				if player:askForSkillInvoke("crYeXin", data) then
					room:broadcastSkillInvoke("crYeXin") --播放配音
					room:notifySkillInvoked(player, "crYeXin") --显示技能发动
					local id = room:drawCard()
					player:addToPile("crYeXinPile", id, true)
				end
			end
		end
		return false
	end,
}
--添加技能
AnJiang:addSkill(YeXin)
ZhongHui:addRelateSkill("crYeXin")
--翻译信息
sgs.LoadTranslationTable{
	["crYeXin"] = "野心",
	[":crYeXin"] = "你造成或受到一次伤害时，你可以将牌堆顶的一张牌置于你的武将牌上，称为“权”。<font color=\"green\"><b>阶段技<b></font>，你可以用至少一张手牌交换等量的“权”。",
	["$crYeXin"] = "非我族者，其心可诛！",
	["crYeXinPile"] = "权",
	["cryexin"] = "野心",
}
--[[
	技能：自立（觉醒技）
	描述：准备阶段开始时，若“权”的数目为四张或更多，你失去1点体力上限，获得技能“排异”。
]]--
ZiLi = sgs.CreateTriggerSkill{
	name = "crZiLi",
	frequency = sgs.Skill_Wake,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Start then
			local pile = player:getPile("crYeXinPile")
			if pile:length() >= 4 then
				local room = player:getRoom()
				room:broadcastSkillInvoke("crZiLi") --播放配音
				room:doLightbox("$crZhongHuiAnimate") --显示全屏信息特效
				room:notifySkillInvoked(player, "crZiLi") --显示技能发动
				room:setPlayerMark(player, "crZiLiWaked", 1)
				room:loseMaxHp(player, 1)
				if player:isAlive() then
					room:handleAcquireDetachSkills(player, "crPaiYi")
					player:gainMark("@waked", 1)
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		if target and target:isAlive() then
			if target:hasSkill("crZiLi") then
				return target:getMark("crZiLiWaked") == 0
			end
		end
		return false
	end,
}
--添加技能
ZhongHui:addSkill(ZiLi)
--翻译信息
sgs.LoadTranslationTable{
	["crZiLi"] = "自立",
	[":crZiLi"] = "<font color=\"purple\"><b>觉醒技</b></font>，准备阶段开始时，若“权”的数目为四张或更多，你失去1点体力上限，获得技能“排异”。\
\
★<b>排异</b>: 回合结束阶段开始时，你可以将一张“权”置入一个合理的区域。若该区域不为你的区域，你可以摸一张牌。",
	["$crZiLi"] = "以我之才，何必屈人之下？",
}
--[[
	技能：排异
	描述：回合结束阶段开始时，你可以将一张“权”置入一个合理的区域。若该区域不为你的区域，你可以摸一张牌。
]]--
PaiYi = sgs.CreateTriggerSkill{
	name = "crPaiYi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Finish then
			local pile = player:getPile("crYeXinPile")
			if pile:isEmpty() then
				return false
			end
			if player:askForSkillInvoke("crPaiYi", data) then
				local room = player:getRoom()
				room:fillAG(pile, player)
				local id = room:askForAG(player, pile, true, "crPaiYi")
				room:clearAG(player)
				if id == -1 then
					return false
				end
				local alives = room:getAlivePlayers()
				local card = sgs.Sanguosha:getCard(id)
				local prompt = string.format("@crPaiYi:::%s:", card:objectName())
				room:setPlayerMark(player, "crPaiYiID", id) --For AI
				local target = room:askForPlayerChosen(player, alives, "crPaiYi", prompt, true)
				room:setPlayerMark(player, "crPaiYiID", 0) --For AI
				if target then
					local choices = {"hand"}
					if card:isKindOf("EquipCard") then
						if card:isKindOf("Weapon") and target:getWeapon() then
						elseif card:isKindOf("Armor") and target:getArmor() then
						elseif card:isKindOf("DefensiveHorse") and target:getDefensiveHorse() then
						elseif card:isKindOf("OffensiveHorse") and target:getOffensiveHorse() then
						elseif card:isKindOf("Treasure") and target:getTreasure() then
						else
							table.insert(choices, "equip")
						end
					elseif card:isKindOf("DelayedTrick") then
						if not target:containsTrick(card:objectName()) then
							table.insert(choices, "trick")
						end
					end
					choices = table.concat(choices, "+")
					local ai_data = sgs.QVariant()
					ai_data:setValue(target)
					player:setTag("crPaiYiTarget", ai_data) --For AI
					room:setPlayerMark(player, "crPaiYiID", id) --For AI
					local choice = room:askForChoice(player, "crPaiYi", choices, ai_data)
					room:setPlayerMark(player, "crPaiYiID", 0) --For AI
					player:removeTag("crPaiYiTarget") --For AI
					local place = nil
					if choice == "hand" then
						place = sgs.Player_PlaceHand
					elseif choice == "equip" then
						place = sgs.Player_PlaceEquip
					elseif choice == "trick" then
						place = sgs.Player_PlaceDelayedTrick
					end
					local move = sgs.CardsMoveStruct()
					move.card_ids:append(id)
					move.to = target
					move.to_place = place
					move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_PUT, player:objectName())
					room:moveCardsAtomic(move, true)
					if player:objectName() == target:objectName() then
						return false
					end
					if player:askForSkillInvoke("crPaiYiDraw", data) then
						room:drawCards(player, 1, "crPaiYi")
					end
				end
			end
		end
		return false
	end,
}
--添加技能
AnJiang:addSkill(PaiYi)
ZhongHui:addRelateSkill("crPaiYi")
--翻译信息
sgs.LoadTranslationTable{
	["crPaiYi"] = "排异",
	[":crPaiYi"] = "回合结束阶段开始时，你可以将一张“权”置入一个合理的区域。若该区域不为你的区域，你可以摸一张牌。",
	["$crPaiYi"] = "待我设计构陷之",
	["@crPaiYi"] = "排异：您可以选择一名目标角色，将这张【%arg】置入该角色的一个合理的区域",
	["crPaiYi:hand"] = "手牌区",
	["crPaiYi:equip"] = "装备区",
	["crPaiYi:trick"] = "判定区",
	["crPaiYiDraw"] = "排异·摸牌",
}
--[[****************************************************************
	编号：CCC - 04
	武将：祢衡
	称号：孤胆愤青
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
MiHeng = sgs.General(extension, "crMiHeng", "god", 3)
--翻译信息
sgs.LoadTranslationTable{
	["crMiHeng"] = "祢衡",
	["&crMiHeng"] = "祢衡",
	["#crMiHeng"] = "孤胆愤青",
	["designer:crMiHeng"] = "Log67、宇文天启",
	["cv:crMiHeng"] = "无",
	["illustrator:crMiHeng"] = "dannyke画客",
	["~crMiHeng"] = "独在异乡为异客，穿越之后倍思亲……",
}
--[[
	技能：语录
	描述：出牌阶段，你可以将2~5张手牌按一定顺序移出游戏作为语录的词汇。
	（经典模式：黑桃视为〖日〗，红桃视为〖我〗，梅花视为〖妹〗，方片视为〖你〗）
	（纯洁模式：黑桃视为〖伴〗，红桃视为〖酱〗，梅花视为〖香〗，方片视为〖卤〗）
	附注：根据原版代码，此技能的实际效果为——
		出牌阶段，你可以将至少一张手牌按一定顺序置于你的武将牌上，称为“词汇”。
]]--
YuLuCard = sgs.CreateSkillCard{
	name = "crYuLuCard",
	--skill_name = "crYuLu",
	target_fixed = true,
	will_throw = false,
	mute = true,
	on_use = function(self, room, source, targets)
		room:broadcastSkillInvoke("crYuLu") --播放配音
		room:notifySkillInvoked(source, "crYuLu") --显示技能发动
		source:addToPile("crYuLuPile", self)
	end,
}
YuLuVS = sgs.CreateViewAsSkill{
	name = "crYuLu",
	n = 999,
	view_filter = function(self, selected, to_select)
		return not to_select:isEquipped()
	end,
	view_as = function(self, cards)
		if #cards >= 0 then
			local card = YuLuCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		if player:isKongcheng() then
			return false
		end
		return true
	end,
}
YuLu = sgs.CreateTriggerSkill{
	name = "crYuLu",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.GameStart},
	view_as_skill = YuLuVS,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local choice = room:askForChoice(player, "crYuLu", "nos+neo", data)
		if choice == "nos" then
			room:setPlayerMark(player, "crYuLuMode", 0)
		elseif choice == "neo" then
			room:setPlayerMark(player, "crYuLuMode", 1)
		end
		return false
	end,
}
--添加技能
MiHeng:addSkill(YuLu)
--翻译信息
sgs.LoadTranslationTable{
	["crYuLu"] = "语录",
	[":crYuLu"] = "出牌阶段，你可以将2~5张手牌按一定顺序移出游戏作为语录的词汇。",
	["$crYuLu"] = "技能 语录 的台词",
	["crYuLuPile"] = "词汇",
	["crYuLu:nos"] = "我已满十八岁，进入经典模式",
	["crYuLu:neo"] = "我未满十八岁，进入纯洁模式",
	["crYuLu_Spade"] = "〖伴〗",
	["crYuLu_Heart"] = "〖酱〗",
	["crYuLu_Club"] = "〖香〗",
	["crYuLu_Diamond"] = "〖卤〗",
	["crYuLu_SpadeX"] = "〖日〗",
	["crYuLu_HeartX"] = "〖我〗",
	["crYuLu_ClubX"] = "〖妹〗",
	["crYuLu_DiamondX"] = "〖你〗",
	["cryulu"] = "语录",
}
--[[
	技能：怒骂
	描述：回合结束阶段，你可以大声朗读（使用）当前语录（见详解）。
]]--
NuMaViewCard = sgs.CreateSkillCard{
	name = "crNuMaViewCard",
	--skill_name = "crNuMa",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_use = function(self, room, source, targets)
		local pile = source:getPile("crYuLuPile")
		local reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_EXCHANGE_FROM_PILE, source:objectName())
		while not pile:isEmpty() do
			room:fillAG(pile, source)
			local id = room:askForAG(source, pile, true, "crNuMa")
			room:clearAG(source)
			if id > 0 then
				pile:removeOne(id)
				local card = sgs.Sanguosha:getCard(id)
				room:moveCardTo(card, source, sgs.Player_PlaceHand, reason, false)
			else
				break
			end
		end
	end,
}
NuMaCard = sgs.CreateSkillCard{
	name = "crNuMaCard",
	--skill_name = "crNuMa",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		if #targets == 0 then
			return true
		elseif #targets == 1 then
			return not to_select:isKongcheng()
		end
		return false
	end,
	feasible = function(self, targets)
		return #targets == 2
	end,
	about_to_use = function(self, room, use)
		self:cardOnUse(room, use)
	end,
	on_use = function(self, room, source, targets)
		local playerA, playerB = targets[1], targets[2]
		if playerB:isKongcheng() then
			return 
		end
		room:showAllCards(playerB, playerA)
	end,
}
NuMaVS = sgs.CreateViewAsSkill{
	name = "crNuMa",
	n = 0,
	ask = "",
	view_as = function(self, cards)
		if ask == "" then
			return NuMaViewCard:clone()
		elseif ask == "@@crNuMa" then
			return NuMaCard:clone()
		end
	end,
	enabled_at_play = function(self, player)
		ask = ""
		return not player:getPile("crYuLuPile"):isEmpty()
	end,
	enabled_at_response = function(self, player, pattern)
		ask = pattern
		return pattern == "@@crNuMa"
	end,
}
NuMa = sgs.CreateTriggerSkill{
	name = "crNuMa",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EventPhaseStart},
	view_as_skill = NuMaVS,
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Finish then
			local pile = player:getPile("crYuLuPile")
			if pile:isEmpty() then
				return false
			end
			if player:askForSkillInvoke("crNuMa", data) then
				local room = player:getRoom()
				player:clearOnePrivatePile("crYuLuPile")
				local neo = ( player:getMark("crYuLuMode") > 0 )
				local spade = neo and "〖伴〗" or "〖日〗"
				local heart = neo and "〖酱〗" or "〖我〗"
				local club = neo and "〖香〗" or "〖妹〗"
				local diamond = neo and "〖卤〗" or "〖你〗"
				local words, cards = {}, {}
				local code = ""
				local msg = sgs.LogMessage()
				msg.type = "#crNuMa_Speak"
				msg.from = player
				for _,id in sgs.qlist(pile) do
					local card = sgs.Sanguosha:getCard(id)
					table.insert(cards, card)
					local suit = card:getSuitString()
					if suit == "spade" then
						code = code .. "s"
						table.insert(words, spade)
						msg.arg = neo and "crYuLu_Spade" or "crYuLu_SpadeX"
						room:sendLog(msg) --发送提示信息
					elseif suit == "heart" then
						code = code .. "h"
						table.insert(words, heart)
						msg.arg = neo and "crYuLu_Heart" or "crYuLu_HeartX"
						room:sendLog(msg) --发送提示信息
					elseif suit == "club" then
						code = code .. "c"
						table.insert(words, club)
						msg.arg = neo and "crYuLu_Club" or "crYuLu_ClubX"
						room:sendLog(msg) --发送提示信息
					elseif suit == "diamond" then
						code = code .. "d"
						table.insert(words, diamond)
						msg.arg = neo and "crYuLu_Diamond" or "crYuLu_DiamondX"
						room:sendLog(msg) --发送提示信息
					end
				end
				player:speak(table.concat(words, ""))
				--Case01：回复一点体力
				if code == "hc" then
					if player:isWounded() then
						local recover = sgs.RecoverStruct()
						recover.who = player
						recover.recover = 1
						room:recover(player, recover)
					end
				--Case02：令一名角色弃两张牌
				elseif code == "dc" then
					local alives = room:getAlivePlayers()
					local victims = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if not p:isNude() then
							victims:append(p)
						end
					end
					if victims:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case02_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case02"
						room:sendLog(msg) --发送提示信息
					else
						local victim = room:askForPlayerChosen(player, victims, "crNuMa_Case02", "@crNuMa_Case02", true)
						if victim then
							room:askForDiscard(victim, "crNuMa_Case02", 2, 2, false, true)
						end
					end
				--Case03：清空一名角色的判定区
				elseif code == "cc" then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if not p:getJudgingArea():isEmpty() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case03_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case03"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case03", "@crNuMa_Case03", true)
						if target then
							local throw = sgs.CardsMoveStruct()
							throw.card_ids = target:getJudgingAreaID()
							throw.from = target
							throw.from_place = sgs.Player_PlaceDelayedTrick
							throw.to = nil
							throw.to_place = sgs.Player_DiscardPile
							throw.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_DISMANTLE, target:objectName())
							room:moveCardsAtomic(throw, true)
						end
					end
				--Case04：展示并获得一名角色的一张手牌，令其回复一点体力
				elseif code == "sd" then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if p:isWounded() and not p:isKongcheng() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case04_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case04"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case04", "@crNuMa_Case04", true)
						if target then
							local card = room:askForCardShow(target, player, "crNuMa_Case04")
							if card then
								room:obtainCard(player, card, true)
								local recover = sgs.RecoverStruct()
								recover.who = player
								recover.recover = 1
								room:recover(target, recover)
							end
						end
					end
				--Case05：进行一次判定，若结果为桃或桃园结义，获得技能“反唇”
				elseif code == "hs" then
					local judge = sgs.JudgeStruct()
					judge.who = player
					judge.reason = "crNuMa_Case05"
					judge.pattern = "Peach,GodSalvation"
					judge.good = true
					room:judge(judge)
					if judge:isGood() then
						room:handleAcquireDetachSkills(player, "crFanChun")
					end
				--Case06：与一名受伤的女性角色各回复一点体力
				elseif code == "hsc" then
					local others = room:getOtherPlayers(player)
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(others) do
						if p:isFemale() and p:isWounded() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case06_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case06"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case06", "@crNuMa_Case06", true)
						if target then
							local recover = sgs.RecoverStruct()
							recover.who = player
							recover.recover = 1
							if player:isWounded() then
								room:recover(player, recover)
							end
							room:recover(target, recover)
						end
					end
				--Case07：与一名受伤的男性角色各回复一点体力
				elseif code == "hsd" then
					local others = room:getOtherPlayers(player)
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(others) do
						if p:isMale() and p:isWounded() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case07_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case07"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case07", "@crNuMa_Case07", true)
						if target then
							local recover = sgs.RecoverStruct()
							recover.who = player
							recover.recover = 1
							if player:isWounded() then
								room:recover(player, recover)
							end
							room:recover(target, recover)
						end
					end
				--Case08：令一名其他角色杀自己，否则获得其所有牌
				elseif code == "dsh" then
					local others = room:getOtherPlayers(player)
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(others) do
						if p:canSlash(player) then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case08_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case08"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case08", "@crNuMa_Case08", true)
						if target then
							local prompt = string.format("@crNuMa_Case08_askForSlash:%s:", player:objectName())
							local slash = room:askForUseSlashTo(target, player, prompt, true, true)
							if slash then
							elseif target:isNude() then
							else
								local moves = sgs.CardsMoveList()
								local move = sgs.CardsMoveStruct()
								move.from = target
								move.to = player
								move.to_place = sgs.Player_PlaceHand
								move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_ROB, player:objectName())
								if not target:isKongcheng() then
									move.card_ids = target:handCards()
									move.from_place = sgs.Player_PlaceHand
									moves:append(move)
								end
								if target:hasEquip() then
									local equips = target:getEquips()
									move.card_ids = sgs.IntList()
									for _,equip in sgs.qlist(equips) do
										local id = equip:getEffectiveId()
										move.card_ids:append(id)
									end
									move.from_place = sgs.Player_PlaceEquip
									moves:append(move)
								end
								room:moveCardsAtomic(moves, false)
							end
						end
					end
				--Case09：令一名角色对自己造成一点伤害，然后其回复一点体力
				elseif code == "shc" then
					local alives = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player, alives, "crNuMa_Case09", "@crNuMa_Case09", true)
					if target then
						local damage = sgs.DamageStruct()
						damage.from = target
						damage.to = player
						damage.damage = 1
						room:damage(damage)
						if target:isAlive() and target:isWounded() then
							local recover = sgs.RecoverStruct()
							recover.who = player
							recover.recover = 1
							room:recover(target, recover)
						end
					end
				--Case10：自己翻面并摸三张牌
				elseif code == "hhh" then
					player:turnOver()
					room:drawCards(player, 3, "crNuMa_Case10")
				--Case11：令一名角色翻面并摸X张牌，其中X为自己已损失的体力
				elseif code == "sss" then
					local alives = room:getAlivePlayers()
					local x = player:getLostHp()
					local prompt = string.format("@crNuMa_Case11:::%d", x)
					local target = room:askForPlayerChosen(player, alives, "crNuMa_Case11", prompt, true)
					if target then
						target:turnOver()
						if x > 0 then
							room:drawCards(target, x, "crNuMa_Case11")
						end
					end
				--Case12：令一名角色获得语录表中所有牌
				elseif code == "ddd" then
					local alives = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player, alives, "crNuMa_Case12", "@crNuMa_Case12", true)
					if target then
						local move = sgs.CardsMoveStruct()
						move.card_ids = pile
						move.to = target
						move.to_place = sgs.Player_PlaceHand
						move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_GOTCARD, target:objectName())
						room:moveCardsAtomic(move, true)
					end
				--Case13：清空一名角色的装备区
				elseif code == "ccc" then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if p:hasEquip() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case13_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case13"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case13", "@crNuMa_Case13", true)
						if target then
							target:throwAllEquips()
						end
					end
				--Case14：清空语录表并指定一名角色获得一个额外的回合
				elseif code == "dcdc" then
					local alives = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player, alives, "crNuMa_Case14", "@crNuMa_Case14", true)
					if target then
						target:gainAnExtraTurn()
					end
				--Case15：视为对一名角色使用了一张杀，属性待定
				elseif code == "sdc" then
					local id = pile:first()
					local card = sgs.Sanguosha:getCard(id)
					local point = card:getNumber()
					local slash = nil
					if point < 5 then
						slash = sgs.Sanguosha:cloneCard("thunder_slash", sgs.Card_NoSuit, 0)
					elseif point > 9 then
						slash = sgs.Sanguosha:cloneCard("fire_slash", sgs.Card_NoSuit, 0)
					else
						slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
					end
					slash:setSkillName("crNuMa_Case15")
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if player:canSlash(p, slash) then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						slash:deleteLater()
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case15_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case15"
						msg.arg2 = slash:objectName()
						room:sendLog(msg) --发送提示信息
					else
						local prompt = string.format("@crNuMa_Case15:::%s:", slash:objectName())
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case15", prompt, true)
						if target then
							local use = sgs.CardUseStruct()
							use.from = player
							use.to:append(target)
							use.card = slash
							room:useCard(use, false)
						else
							slash:deleteLater()
						end
					end
				--Case16：视为对一名角色使用了一张酒杀
				elseif code == "hsdc" then
					local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
					slash:setSkillName("crNuMa_Case16")
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if player:canSlash(p, slash) then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						slash:deleteLater()
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case16_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case16"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case16", "@crNuMa_Case16", true)
						if target then
							local analeptic = sgs.Sanguosha:cloneCard("analeptic", sgs.Card_NoSuit, 0)
							analeptic:setSkillName("crNuMa_Case16")
							local use = sgs.CardUseStruct()
							use.from = player
							use.card = analeptic
							room:useCard(use, false)
							use.card = slash
							use.to:append(target)
							room:useCard(use, false)
						else
							slash:deleteLater()
						end
					end
				--Case17：回复所有体力
				elseif code == "ccsh" then
					if player:isWounded() then
						local lost = player:getLostHp()
						local recover = sgs.RecoverStruct()
						recover.who = player
						recover.recover = lost
						room:recover(player, recover)
					end
				--Case18：令一名角色观看另一名角色的所有手牌
				elseif code == "dsdc" then
					room:askForUseCard(player, "@@crNuMa", "@crNuMa_Case18")
				--Case19：自杀
				elseif code == "dshc" then
					local reason = sgs.DamageStruct()
					reason.from = player
					reason.to = player
					room:killPlayer(player, reason)
				--Case20：自己变身为邓艾
				elseif code == "hhhhh" then
					local isSecondaryHero = false
					if player:getGeneralName() ~= "crMiHeng" then
						if player:getGeneral2Name() == "crMiHeng" then
							isSecondaryHero = true
						end
					end
					room:changeHero(player, "dengai", false, false, isSecondaryHero, true)
				--Case21：弃置一名角色四张牌，然后对自己造成2点伤害
				elseif code == "dshcc" then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if not p:isNude() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case21_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case21"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case21", "@crNuMa_Case21", true)
						if target then
							for i=1, 4, 1 do
								if target:isNude() then
									break
								end
								local id = room:askForCardChosen(player, target, "he", "crNuMa_Case21")
								if id > 0 then
									if player:canDiscard(target, id) then
										room:throwCard(id, target, player)
									else
									end
								else
									break
								end
							end
							local damage = sgs.DamageStruct()
							damage.from = player
							damage.to = player
							damage.damage = 2
							room:damage(damage)
						end
					end
				--Case22：限定技，对一名角色造成一点雷电伤害、一点火焰伤害、一点普通伤害，然后自己失去2点体力
				elseif code == "hsdcc" and player:getMark("crNuMa_hsdcc") == 0 then
					local alives = room:getAlivePlayers()
					local target = room:askForPlayerChosen(player, alives, "crNuMa_Case22", "@crNuMa_Case22", true)
					if target then
						room:setPlayerMark(player, "crNuMa_hsdcc", 1)
						local damage = sgs.DamageStruct()
						damage.from = player
						damage.to = target
						damage.damage = 1
						damage.nature = sgs.DamageStruct_Thunder
						room:damage(damage)
						if target:isAlive() then
							damage.nature = sgs.DamageStruct_Fire 
							room:damage(damage)
						end
						if target:isAlive() then
							damage.nature = sgs.DamageStruct_Normal
							room:damage(damage)
						end
						if player:isAlive() then
							room:loseHp(player, 2)
						end
					end
				--Case23：限定技，获得所有角色各一张手牌，然后将自己武将牌翻面
				elseif code == "dcshc" and player:getMark("crNuMa_dcshc") == 0 then
					room:setPlayerMark(player, "crNuMa_dcshc", 1)
					local alives = room:getAlivePlayers()
					for _,p in sgs.qlist(alives) do
						if not p:isKongcheng() then
							local id = room:askForCardChosen(player, p, "h", "crNuMa_Case23")
							if id > 0 then
								room:obtainCard(player, id, false)
							end
						end
					end
					player:turnOver()
				--Case24：限定技，立即引爆场上的一张闪电
				elseif code == "ssdcc" and player:getMark("crNuMa_ssdcc") == 0 then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if p:containsTrick("lightning") then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case24_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case24"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case24", "@crNuMa_Case24", true)
						if target then
							room:setPlayerMark(player, "crNuMa_ssdcc", 1)
							local judges = target:getJudgingArea()
							for _,lightning in sgs.qlist(judges) do
								if lightning:isKindOf("Lightning") then
									local id = lightning:getEffectiveId()
									local move = sgs.CardsMoveStruct()
									move.from = target
									move.from_place = sgs.Player_PlaceDelayedTrick
									move.to = nil
									move.to_place = sgs.Player_PlaceTable
									move.card_ids:append(id)
									move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_PUT, target:objectName())
									room:moveCardsAtomic(move, true)
									local damage = sgs.DamageStruct()
									damage.from = nil
									damage.to = target
									damage.card = lightning
									damage.damage = 3
									damage.nature = sgs.DamageStruct_Thunder
									room:damage(damage)
									if room:getCardPlace(id) == sgs.Player_PlaceTable then
										move = sgs.CardsMoveStruct()
										move.from = nil
										move.from_place = sgs.Player_PlaceTable
										move.to = nil
										move.to_place = sgs.Player_DiscardPile
										move.card_ids:append(id)
										move.reason = sgs.CardMoveReason(
											sgs.CardMoveReason_S_REASON_NATURAL_ENTER, 
											target:objectName()
										)
										room:moveCardsAtomic(move, true)
									end
									break
								end
							end
						end
					end
				--Case25：限定技，令一名体力上限比你多的角色增加一点体力上限，获得一个负面技能
				elseif code == "ssscc" and player:getMark("crNuMa_ssscc") == 0 then
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if p:getMaxHp() > player:getMaxHp() then
							targets:append(p)
						end
					end
					if targets:isEmpty() then
						local msg = sgs.LogMessage()
						msg.type = "#crNuMa_Case25_NoTarget"
						msg.from = player
						msg.arg = "crNuMa_Case25"
						room:sendLog(msg) --发送提示信息
					else
						local target = room:askForPlayerChosen(player, targets, "crNuMa_Case25", "@crNuMa_Case25", true)
						if target then
							room:setPlayerMark(player, "crNuMa_ssscc", 1)
							local maxhp = target:getMaxHp() + 1
							room:setPlayerProperty(target, "maxhp", sgs.QVariant(maxhp))
							local choices = "benghuai+wumou+shiyong+yaowu+chanyuan+zaoyao+chouhai"
							local ai_data = sgs.QVariant()
							ai_data:setValue(target)
							local choice = room:askForChoice(player, "crNuMa_Case25", choices, ai_data)
							room:handleAcquireDetachSkills(target, choice)
						end
					end
				--Case26：变为素将，然后增加2点体力上限
				elseif #words == 4 then
					local maxhp = player:getMaxHp() + 2
					if player:isFemale() then
						room:changeHero(player, "sujiangf", false, false, false, true)
					else
						room:changeHero(player, "sujiang", false, false, false, true)
					end
					local secondaryHero = player:getGeneral2()
					if secondaryHero then
						if secondaryHero:isFemale() then
							room:changeHero(player, "sujiangf", false, false, true, true)
						else
							room:changeHero(player, "sujiang", false, false, true, true)
						end
					end
					room:setPlayerProperty(player, "maxhp", sgs.QVariant(maxhp))
					local skills = player:getVisibleSkillList()
					for _,skill in sgs.qlist(skills) do
						if skill:inherits("SPConvertSkill") then
						elseif skill:isAttachedLordSkill() then
						else
							room:handleAcquireDetachSkills(player, "-"..skill:objectName())
						end
					end
				--Case27：限定技，失去一点体力上限，获得技能“龙魂”
				elseif #words == 5 and player:getMark("crNuMa_five_words") == 0 then
					room:setPlayerMark(player, "crNuMa_five_words", 1)
					room:loseMaxHp(player, 1)
					if player:isAlive() then
						room:handleAcquireDetachSkills(player, "longhun")
					end
				--Case28：限定技，失去2点体力上限，获得技能“无言”、“不屈”
				elseif #words > 5 and player:getMark("crNuMa_other_words") == 0 then
					room:setPlayerMark(player, "crNuMa_other_words", 1)
					room:loseMaxHp(player, 2)
					if player:isAlive() then
						room:handleAcquireDetachSkills(player, "wuyan|buqu")
					end
				--Case29：无效果
				else
					local msg = sgs.LogMessage()
					msg.type = "#crNuMa_Case29_NoEffect"
					msg.from = player
					msg.arg = "crNuMa_Case29"
					room:sendLog(msg) --发送提示信息
				end
			end
		end
		return false
	end,
}
--添加技能
MiHeng:addSkill(NuMa)
--翻译信息
sgs.LoadTranslationTable{
	["crNuMa"] = "怒骂",
	[":crNuMa"] = "回合结束阶段，你可以大声朗读（使用）当前语录（见详解）。",
	["#crNuMa_Speak"] = "%from 说：%arg",
	["crNuMa_Case02"] = "怒骂",
	["@crNuMa_Case02"] = "怒骂02：您可以选择一名角色，令其弃置两张牌",
	["#crNuMa_Case02_NoTarget"] = "%from 发动了“%arg”，但由于所有角色均无牌可弃，取消技能的后续效果",
	["crNuMa_Case03"] = "怒骂",
	["@crNuMa_Case03"] = "怒骂03：您可以选择一名角色，弃置其判定区的所有牌",
	["#crNuMa_Case03_NoTarget"] = "%from 发动了“%arg”，但由于所有角色判定区均无牌，取消技能的后续效果",
	["crNuMa_Case04"] = "怒骂",
	["@crNuMa_Case04"] = "怒骂04：您可以选择一名角色，令其展示一张手牌，然后你获得其展示的牌并令其回复1点体力",
	["#crNuMa_Case04_NoTarget"] = "%from 发动了“%arg”，但由于没有又有手牌又受伤的角色，取消技能的后续效果",
	["crNuMa_Case05"] = "怒骂",
	["crNuMa_Case06"] = "怒骂",
	["@crNuMa_Case06"] = "怒骂06：您可以选择一名受伤的女性角色，你与其依次回复1点体力",
	["#crNuMa_Case06_NoTarget"] = "%from 发动了“%arg”，但由于没有受伤的女性角色，取消技能的后续效果",
	["crNuMa_Case07"] = "怒骂",
	["@crNuMa_Case07"] = "怒骂07：您可以选择一名受伤的男性角色，你与其依次回复1点体力",
	["#crNuMa_Case07_NoTarget"] = "%from 发动了“%arg”，但由于没有受伤的男性角色，取消技能的后续效果",
	["crNuMa_Case08"] = "怒骂",
	["@crNuMa_Case08"] = "怒骂08：您可以选择一名其他角色，令其对你使用一张【杀】，否则你获得其所有牌",
	["#crNuMa_Case08_NoTarget"] = "%from 发动了“%arg”，但由于没有可以对自己使用【杀】的角色，取消技能的后续效果",
	["@crNuMa_Case08_askForSlash"] = "怒骂：请对 %src 使用一张【杀】，否则其将获得你所有的牌",
	["crNuMa_Case09"] = "怒骂",
	["@crNuMa_Case09"] = "怒骂09：您可以选择一名角色，令其对你造成1点伤害，然后其回复1点体力",
	["crNuMa_Case10"] = "怒骂",
	["crNuMa_Case11"] = "怒骂",
	["@crNuMa_Case11"] = "怒骂11：您可以选择一名角色，令其翻面并摸 %arg 张牌",
	["crNuMa_Case12"] = "怒骂",
	["@crNuMa_Case12"] = "怒骂12：您可以选择一名角色，令其收回“词汇”中的所有牌",
	["crNuMa_Case13"] = "怒骂",
	["@crNuMa_Case13"] = "怒骂13：您可以选择一名角色，令其弃置其装备区的所有牌",
	["#crNuMa_Case13_NoTarget"] = "%from 发动了“%arg”，但由于没有装备区有牌的角色，取消技能的后续效果",
	["crNuMa_Case14"] = "怒骂",
	["@crNuMa_Case14"] = "怒骂14：您可以选择一名角色，令其获得一个额外的回合",
	["crNuMa_Case15"] = "怒骂",
	["@crNuMa_Case15"] = "怒骂15：您可以选择一名角色，视为对其使用了一张【%arg】",
	["#crNuMa_Case15_NoTarget"] = "%from 发动了“%arg”，但由于没有可以使用【%arg2】的角色，取消技能的后续效果",
	["crNuMa_Case16"] = "怒骂",
	["@crNuMa_Case16"] = "怒骂16：您可以选择一名角色，视为对其使用了一张【酒】【杀】",
	["#crNuMa_Case16_NoTarget"] = "%from 发动了“%arg”，但由于没有可以使用【杀】的角色，取消技能的后续效果",
	["@crNuMa_Case18"] = "怒骂18：您可以依次选择两名角色，令第一名角色观看第二名角色的所有手牌",
	["crNuMa_Case21"] = "怒骂",
	["@crNuMa_Case21"] = "怒骂21：您可以选择一名角色，弃置其四张牌，然后对自己造成2点伤害",
	["#crNuMa_Case21_NoTarget"] = "%from 发动了“%arg”，但由于所有角色均无牌可弃，取消技能的后续效果",
	["crNuMa_Case22"] = "怒骂",
	["@crNuMa_Case22"] = "怒骂22：限定技，您可以选择一名角色，对其依次造成1点雷电伤害、1点火焰伤害、1点普通伤害，然后你失去2点体力",
	["crNuMa_Case23"] = "怒骂",
	["crNuMa_Case24"] = "怒骂",
	["@crNuMa_Case24"] = "怒骂24：限定技，您可以选择一名判定区有【闪电】的角色，令此【闪电】立即生效",
	["#crNuMa_Case24_NoTarget"] = "%from 发动了“%arg”，但由于场上没有【闪电】，取消技能的后续效果",
	["crNuMa_Case25"] = "怒骂",
	["@crNuMa_Case25"] = "怒骂25：限定技，您可以选择一名体力上限比你多的角色，令其增加1点体力上限，并获得一个负面技能",
	["#crNuMa_Case25_NoTarget"] = "%from 发动了“%arg”，但由于没有体力上限多于自己的角色，取消技能的后续效果",
	["crNuMa_Case29"] = "怒骂",
	["#crNuMa_Case29_NoEffect"] = "%from 发动了“%arg”，但是！没有产生任何效果！",
	["crnumaview"] = "怒骂·技术交流",
	["crnuma"] = "怒骂",
}
--[[
	技能：桀骜（锁定技）
	描述：回合开始阶段，若你的手牌数小于当前体力值，你摸2张牌。
]]--
JieAo = sgs.CreateTriggerSkill{
	name = "crJieAo",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Start then
			if player:getHandcardNum() < player:getHp() then
				local room = player:getRoom()
				room:broadcastSkillInvoke("crJieAo") --播放配音
				room:sendCompulsoryTriggerLog(player, "crJieAo", false) --发送提示信息
				room:notifySkillInvoked(player, "crJieAo") --显示技能发动
				room:drawCards(player, 2, "crJieAo")
			end
		end
		return false
	end,
}
--添加技能
MiHeng:addSkill(JieAo)
--翻译信息
sgs.LoadTranslationTable{
	["crJieAo"] = "桀骜",
	[":crJieAo"] = "<font color=\"blue\"><b>锁定技</b></font>，回合开始阶段，若你的手牌数小于当前体力值，你摸2张牌。",
}
--[[
	技能：反唇
	描述：你可以把对你造成伤害的牌加入语录表。
]]--
FanChun = sgs.CreateTriggerSkill{
	name = "crFanChun",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local card = damage.card
		if card then
			if card:isVirtualCard() and card:subcardsLength() == 0 then
				return false
			end
			local room = player:getRoom()
			if room:askForSkillInvoke(player, "crFanChun", data) then
				room:broadcastSkillInvoke("crFanChun") --播放配音
				room:notifySkillInvoked(player, "crFanChun") --显示技能发动
				player:addToPile("crYuLuPile", card)
			end
		end
		return false
	end,
}
--添加技能
AnJiang:addSkill(FanChun)
MiHeng:addRelateSkill("crFanChun")
--翻译信息
sgs.LoadTranslationTable{
	["crFanChun"] = "反唇",
	[":crFanChun"] = "你可以把对你造成伤害的牌加入语录表。",
}
--[[****************************************************************
	编号：CCC - 05
	武将：十胜郭嘉
	称号：天妒英才
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
GuoJia = sgs.General(extension, "crGuoJia", "god", 3)
--翻译信息
sgs.LoadTranslationTable{
	["crGuoJia"] = "十胜郭嘉",
	["&crGuoJia"] = "郭嘉",
	["#crGuoJia"] = "天妒英才",
	["designer:crGuoJia"] = "民间设计",
	["cv:crGuoJia"] = "官方",
	["illustrator:crGuoJia"] = "KayaK",
	["~crGuoJia"] = "咳咳、咳咳咳咳、咳咳……",
}
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
function tempCard(name)
	local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
	card:deleteLater()
	return card
end
function getShiShengChoices(room, source)
	local choices = {}
	local manFlag, kofFlag, disasterFlag = true, true, true
	local banPackages = sgs.Sanguosha:getBanPackages()
	for _,ban in ipairs(banPackages) do
		if ban == "maneuvering" then
			manFlag = false
		elseif ban == "New1v1Card" then
			kofFlag = false
		elseif ban == "Disaster" then
			disasterFlag = false
		end
	end
	local alives = room:getAlivePlayers()
	local others = room:getOtherPlayers(source)
	local selected = sgs.PlayerList()
	--杀
	local card = tempCard("slash")
	if sgs.Slash_IsAvailable(source) then
		for _,p in sgs.qlist(others) do
			if source:canSlash(p, card) then
				table.insert(choices, "slash")
				if manFlag then
					--火杀
					table.insert(choices, "fire_slash")
					--雷杀
					table.insert(choices, "thunder_slash")
				end
				break
			end
		end
	end
	--桃
	if source:isWounded() then
		if not source:hasFlag("Global_PreventPeach") then
			card = tempCard("peach")
			if not source:isProhibited(source, card) then
				table.insert(choices, "peach")
			end
		end
	end
	--酒
	if manFlag then
		if sgs.Analeptic_IsAvailable(source) then
			local card = tempCard("analeptic")
			if not source:isProhibited(source, card) then
				table.insert(choices, "analeptic")
			end
		end
	end
	--桃园结义
	local card = tempCard("god_salvation")
	for _,p in sgs.qlist(alives) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "god_salvation")
			break
		end
	end
	--五谷丰登
	local card = tempCard("amazing_grace")
	for _,p in sgs.qlist(alives) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "amazing_grace")
			break
		end
	end
	--南蛮入侵
	local card = tempCard("savage_assault")
	for _,p in sgs.qlist(others) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "savage_assault")
			break
		end
	end
	--万箭齐发
	local card = tempCard("archery_attack")
	for _,p in sgs.qlist(others) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "archery_attack")
			break
		end
	end
	--借刀杀人
	local card = tempCard("collateral")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "collateral")
			break
		end
	end
	--顺手牵羊
	local card = tempCard("snatch")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "snatch")
			break
		end
	end
	--过河拆桥
	local card = tempCard("dismantlement")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "dismantlement")
			break
		end
	end
	--铁索连环
	if manFlag then
		card = tempCard("iron_chain")
		if card:canRecast() then
			table.insert(choices, "iron_chain")
		else
			for _,p in sgs.qlist(alives) do
				if card:targetFilter(selected, p, source) then
					table.insert(choices, "iron_chain")
					break
				end
			end
		end
	end
	--无中生有
	card = tempCard("ex_nihilo")
	if not source:isProhibited(source, card) then
		table.insert(choices, "ex_nihilo")
	end
	--水淹七军
	if kofFlag then
		card = tempCard("drowning")
		for _,p in sgs.qlist(alives) do
			if card:targetFilter(selected, p, source) then
				table.insert(choices, "drowning")
				break
			end
		end
	end
	--火攻
	if manFlag then
		card = tempCard("fire_attack")
		for _,p in sgs.qlist(alives) do
			if card:targetFilter(selected, p, source) then
				table.insert(choices, "fire_attack")
				break
			end
		end
	end
	--决斗
	card = tempCard("duel")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "duel")
			break
		end
	end
	--乐不思蜀
	card = tempCard("indulgence")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "indulgence")
			break
		end
	end
	--兵粮寸断
	if manFlag then
		card = tempCard("supply_shortage")
		for _,p in sgs.qlist(others) do
			if card:targetFilter(selected, p, source) then
				table.insert(choices, "supply_shortage")
				break
			end
		end
	end
	--闪电
	card = tempCard("lightning")
	if not source:isProhibited(source, card) then
		if not source:containsTrick("lightning") then
			table.insert(choices, "lightning")
		end
	end
	if disasterFlag then
		--火山
		card = tempCard("volcano")
		if not source:isProhibited(source, card) then
			if not source:containsTrick("volcano") then
				table.insert(choices, "volcano")
			end
		end
		--泥石流
		card = tempCard("mudslide")
		if not source:isProhibited(source, card) then
			if not source:containsTrick("mudslide") then
				table.insert(choices, "mudslide")
			end
		end
		--地震
		card = tempCard("earthquake")
		if not source:isProhibited(source, card) then
			if not source:containsTrick("earthquake") then
				table.insert(choices, "earthquake")
			end
		end
		--台风
		card = tempCard("typhoon")
		if not source:isProhibited(source, card) then
			if not source:containsTrick("typhoon") then
				table.insert(choices, "typhoon")
			end
		end
		--洪水
		card = tempCard("deluge")
		if not source:isProhibited(source, card) then
			if not source:containsTrick("deluge") then
				table.insert(choices, "deluge")
			end
		end
	end
	return choices
end
function getSSCard(player)
	local name = player:property("crShiShengType"):toString() or ""
	local card = sgs.Sanguosha:cloneCard(name, sgs.Card_SuitToBeDecided, 0)
	card:setSkillName("crShiSheng")
	return card
end
ShiShengSelectCard = sgs.CreateSkillCard{
	name = "crShiShengSelectCard",
	--skill_name = "crShiSheng",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local card = getSSCard(sgs.Self)
		card:deleteLater()
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetFilter(selected, to_select, sgs.Self)
	end,
	feasible = function(self, targets)
		local card = getSSCard(sgs.Self)
		card:deleteLater()
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetsFeasible(selected, sgs.Self)
	end,
	about_to_use = function(self, room, use)
		if not use.to:isEmpty() then
			local target = use.to:first()
			room:setPlayerFlag(target, "crShiShengFirstTarget")
		end
		self:cardOnUse(room, use)
	end,
	on_use = function(self, room, source, targets)
		local card = getSSCard(source)
		local subcards = source:property("crShiShengIDs"):toIntList()
		room:setPlayerProperty(source, "crShiShengIDs", sgs.QVariant(""))
		room:setPlayerProperty(source, "crShiShengType", sgs.QVariant(""))
		room:setPlayerFlag(source, "-crShiShengSelect")
		if subcards:length() == 1 or card:isKindOf("DelayedTrick") then
			local id = subcards:first()
			local subcard = sgs.Sanguosha:getCard(id)
			local point = subcard:getNumber()
			card:setNumber(point)
			card:addSubcard(id)
			subcards:removeOne(id)
			if not subcards:isEmpty() then
				local move = sgs.CardsMoveStruct()
				move.card_ids = subcards
				move.to = nil
				move.to_place = sgs.Player_DiscardPile
				move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_PUT, source:objectName())
				room:moveCardsAtomic(move, true)
			end
		else
			for _,id in sgs.qlist(subcards) do
				card:addSubcard(id)
			end
		end
		local use = sgs.CardUseStruct()
		use.from = source
		use.card = card
		if card:isKindOf("Collateral") then
			for index, p in ipairs(targets) do
				if p:hasFlag("crShiShengFirstTarget") then
					room:setPlayerFlag(p, "-crShiShengFirstTarget")
					use.to:append(p)
					table.remove(targets, index)
					break
				end
			end
		end
		for _,p in ipairs(targets) do
			use.to:append(p)
		end
		room:useCard(use, true)
	end,
}
ShiShengUseCard = sgs.CreateSkillCard{
	name = "crShiShengUseCard",
	--skill_name = "crShiSheng",
	target_fixed = true,
	will_throw = false,
	mute = true,
	on_validate = function(self, use)
		local source = use.from
		local room = source:getRoom()
		room:setPlayerFlag(source, "-crShiShengUse")
		room:setPlayerMark(source, "crShiShengCase", 0)
		local msg = sgs.LogMessage()
		msg.type = "#crShiShengStartUse"
		msg.from = source
		msg.arg = "crShiSheng"
		room:sendLog(msg) --发送提示信息
		local subcards = self:getSubcards()
		local count = subcards:length()
		local choices = getShiShengChoices(room, source)
		local choice = nil
		if #choices > 10 then
			local ai_data = sgs.QVariant(table.concat(choices, "+"))
			source:setTag("crShiShengAIData", ai_data) --For AI
			local pages = {}
			while true do
				local page = {}
				if #pages > 0 then
					table.insert(page, "last_page")
				end
				local n = math.min(9, #choices)
				for i=1, n, 1 do
					table.insert(page, choices[1])
					table.remove(choices, 1)
				end
				if #choices > 0 then
					table.insert(page, "next_page")
				end
				table.insert(pages, page)
				if #choices == 0 then
					break
				end
			end
			local index = 1
			while true do
				local page = pages[index]
				local items = table.concat(page, "+")
				choice = room:askForChoice(source, "crShiShengType", items, sgs.QVariant(true))
				if choice == "last_page" then
					index = index - 1
				elseif choice == "next_page" then
					index = index + 1
				else
					break
				end
			end
			source:removeTag("crShiShengAIData") --For AI
		else
			choices = table.concat(choices, "+")
			choice = room:askForChoice(source, "crShiShengType", choices)
		end
		msg = sgs.LogMessage()
		msg.type = "#crShiShengTypeChosen"
		msg.from = source
		msg.arg = choice
		room:sendLog(msg) --发送提示信息
		local card = sgs.Sanguosha:cloneCard(choice, sgs.Card_SuitToBeDecided, 0)
		if card:targetFixed() then
			card:setSkillName("crShiSheng")
			if count == 1 or card:isKindOf("DelayedTrick") then
				local id = subcards:first()
				local subcard = sgs.Sanguosha:getCard(id)
				local point = subcard:getNumber()
				card:setNumber(point)
				card:addSubcard(id)
				subcards:removeOne(id)
				if not subcards:isEmpty() then
					local move = sgs.CardsMoveStruct()
					move.card_ids = subcards
					move.to = nil
					move.to_place = sgs.Player_DiscardPile
					move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_PUT, source:objectName())
					room:moveCardsAtomic(move, true)
				end
			else
				for _,id in sgs.qlist(subcards) do
					card:addSubcard(id)
				end
			end
			return card
		end
		local prompt = string.format("@crShiSheng:::%s:", choice)
		room:setPlayerFlag(source, "crShiShengSelect")
		local data = sgs.QVariant()
		data:setValue(subcards)
		room:setPlayerProperty(source, "crShiShengIDs", data)
		room:setPlayerProperty(source, "crShiShengType", sgs.QVariant(choice))
		local success = room:askForUseCard(source, "@@crShiShengSelect", prompt)
		if success then
			return self
		end
		room:setPlayerProperty(source, "crShiShengType", sgs.QVariant(""))
		room:setPlayerProperty(source, "crShiShengIDs", sgs.QVariant(""))
		room:setPlayerFlag(source, "crShiShengSelect")
		local msg = sgs.LogMessage()
		msg.type = "#crShiShengGiveUp"
		msg.from = source
		msg.arg = choice
		room:sendLog(msg) --发送提示信息
	end,
}
ShiShengCard = sgs.CreateSkillCard{
	name = "crShiShengCard",
	--skill_name = "crShiSheng",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_use = function(self, room, source, targets)
		local msg = sgs.LogMessage()
		msg.type = "#crShiShengInvoke"
		msg.from = source
		msg.arg = "crShiSheng"
		room:sendLog(msg) --发送提示信息
		local mark = source:getMark("@crShiShengMark")
		mark = math.min(10, mark)
		local choices = {}
		for index = 1, mark, 1 do
			local item = string.format("Case%d", index)
			table.insert(choices, item)
		end
		table.insert(choices, "cancel")
		choices = table.concat(choices, "+")
		local choice = room:askForChoice(source, "crShiSheng", choices)
		if choice == "cancel" then
			return 
		end
		local case = tonumber( string.sub(choice, 5) )
		msg = sgs.LogMessage()
		msg.type = "#crShiShengCaseChosen"
		msg.from = source
		msg.arg = case
		room:sendLog(msg) --发送提示信息
		if case == 10 then
			source:loseMark("@crShiShengMark", 3)
		elseif case >= 7 then
			source:loseMark("@crShiShengMark", 2)
		elseif case >= 3 then
			source:loseMark("@crShiShengMark", 1)
		end
		local prompt = string.format("@crShiShengCase%d:", case)
		room:setPlayerMark(source, "crShiShengCase", case)
		room:setPlayerFlag(source, "crShiShengUse")
		local success = room:askForUseCard(source, "@@crShiSheng", prompt)
		if not success then
			room:setPlayerFlag(source, "-crShiShengUse")
			room:setPlayerMark(source, "crShiShengCase", 0)
			local msg = sgs.LogMessage()
			msg.type = "#crShiShengFailed"
			msg.from = source
			msg.arg = case
			room:sendLog(msg) ---发送提示信息
		end
	end,
}
ShiShengVS = sgs.CreateViewAsSkill{
	name = "crShiSheng",
	n = 3,
	view_filter = function(self, selected, to_select)
		if sgs.Self:hasFlag("crShiShengUse") then
			local case = sgs.Self:getMark("crShiShengCase")
			if case < 7 and to_select:isEquipped() then
				return false
			end
			if #selected == 0 then
				if case == 1 then
					return to_select:getNumber() == 5
				elseif case == 2 then
					return to_select:getNumber() == 10
				elseif case == 7 then
					return to_select:isKindOf("TrickCard")
				elseif case == 8 then
					return to_select:isKindOf("EquipCard")
				elseif case == 9 then
					return to_select:isKindOf("BasicCard")
				else
					return true
				end
			elseif #selected == 1 then
				if case == 3 then
					if selected[1]:getSuit() == to_select:getSuit() then
						if selected[1]:getNumber() == to_select:getNumber() then
							return true
						end
					end
				elseif case == 4 then
					if selected[1]:getNumber() == to_select:getNumber() then
						return true
					end
				elseif case == 5 then
					if selected[1]:getSuit() == to_select:getSuit() then
						return true
					end
				elseif case == 6 then
					return true
				else
					return false
				end
			elseif #selected == 2 then
				if case == 6 then
					return true
				else
					return false
				end
			end
		elseif sgs.Self:hasFlag("crShiShengSelect") then
			return false
		else
			return false
		end
	end,
	view_as = function(self, cards)
		if sgs.Self:hasFlag("crShiShengUse") then
			local count = #cards
			if count > 0 then
				local case = sgs.Self:getMark("crShiShengCase")
				local ok = false
				if count == 1 then
					if case == 1 or case == 2 or case >= 7 then
						ok = true
					end
				elseif count == 2 then
					if case == 3 or case == 4 or case == 5 then
						ok = true
					end
				elseif count == 3 then
					if case == 6 then
						ok = true
					end
				end
				if ok then
					local card = ShiShengUseCard:clone()
					for _,c in ipairs(cards) do
						card:addSubcard(c)
					end
					return card
				end
			end
		elseif sgs.Self:hasFlag("crShiShengSelect") then
			return ShiShengSelectCard:clone()
		else
			return ShiShengCard:clone()
		end
	end,
	enabled_at_play = function(self, player)
		if player:hasFlag("crShiShengUse") then
			return false
		elseif player:hasFlag("crShiShengSelect") then
			return false
		else
			local mark = player:getMark("@crShiShengMark")
			if mark == 0 then
				return false
			elseif mark < 7 then
				if player:isKongcheng() then
					return false
				end
			elseif player:isNude() then
				return false
			end
			return true
		end
	end,
	enabled_at_response = function(self, player, pattern)
		if player:hasFlag("crShiShengUse") then
			return pattern == "@@crShiSheng"
		elseif player:hasFlag("crShiShengSelect") then
			return pattern == "@@crShiShengSelect"
		else
			return false
		end
	end,
}
ShiSheng = sgs.CreateTriggerSkill{
	name = "crShiSheng",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.GameStart, sgs.Damaged, sgs.Damage},
	view_as_skill = ShiShengVS,
	on_trigger = function(self, event, player, data)
		if player:getMark("@crShiShengMark") < 10 then
			player:gainMark("@crShiShengMark", 1)
		end
		return false
	end,
}
--添加技能
GuoJia:addSkill(ShiSheng)
--翻译信息
sgs.LoadTranslationTable{
	["crShiSheng"] = "十胜",
	[":crShiSheng"] = "游戏开始时，你获得一枚“致胜”标记。每当你受到或造成一次伤害，你获得一枚“致胜”标记（最多十枚）。出牌阶段，若你有：\
1枚“致胜”标记，你可以将一张点数为5的手牌当做任意一张基本牌或锦囊牌使用；\
2枚“致胜”标记，你可以将一张点数为10的手牌当做任意一张基本牌或锦囊牌使用；\
3枚“致胜”标记，你可以弃一枚“致胜”标记，将两张花色、点数均相同的手牌当做任意一张基本牌或锦囊牌使用；\
4枚“致胜”标记，你可以弃一枚“致胜”标记，将两张同点数的手牌当做任意一张基本牌或锦囊牌使用；\
5枚“致胜”标记，你可以弃一枚“致胜”标记，将两张同花色的手牌当做任意一张基本牌或锦囊牌使用；\
6枚“致胜”标记，你可以弃一枚“致胜”标记，将三张手牌当做任意一张基本牌或锦囊牌使用；\
7枚“致胜”标记，你可以弃两枚“致胜”标记，将一张锦囊牌当做任意一张基本牌或锦囊牌使用；\
8枚“致胜”标记，你可以弃两枚“致胜”标记，将一张装备牌当做任意一张基本牌或锦囊牌使用；\
9枚“致胜”标记，你可以弃两枚“致胜”标记，将一张基本牌当做任意一张基本牌或锦囊牌使用；\
10枚“致胜”标记，你可以弃三枚“致胜”标记，将一张牌当做任意一张基本牌或锦囊牌使用。 ",
	["crShiSheng:Case1"] = "[1]一张点数为5的手牌",
	["crShiSheng:Case2"] = "[2]一张点数为10的手牌",
	["crShiSheng:Case3"] = "[3]★两张点数、花色均相同的手牌",
	["crShiSheng:Case4"] = "[4]★两张点数相同的手牌",
	["crShiSheng:Case5"] = "[5]★两张花色相同的手牌",
	["crShiSheng:Case6"] = "[6]★三张手牌",
	["crShiSheng:Case7"] = "[7]★★一张锦囊牌",
	["crShiSheng:Case8"] = "[8]★★一张装备牌",
	["crShiSheng:Case9"] = "[9]★★一张基本牌",
	["crShiSheng:Case10"] = "[10]★★★任意一张牌",
	["@crShiShengCase1"] = "十胜：您可以将一张点数为5的手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase2"] = "十胜：您可以将一张点数为10的手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase3"] = "十胜：您可以将两张花色、点数均相同的手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase4"] = "十胜：您可以将两张同点数的手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase5"] = "十胜：您可以将两张同花色的手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase6"] = "十胜：您可以将三张手牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase7"] = "十胜：您可以将一张锦囊牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase8"] = "十胜：您可以将一张装备牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase9"] = "十胜：您可以将一张基本牌当做任意一张基本牌或锦囊牌使用",
	["@crShiShengCase10"] = "十胜：您可以将一张牌当做任意一张基本牌或锦囊牌使用",
	["#crShiShengInvoke"] = "%arg：等待 %from 选择效果类别……",
	["#crShiShengCaseChosen"] = "%from 选择了类别 %arg，请稍候",
	["#crShiShengStartUse"] = "%arg：等待 %from 选择卡牌类型……",
	["crShiShengType"] = "请选择视为卡牌的种类",
	["crShiShengType:last_page"] = "上一页",
	["crShiShengType:next_page"] = "下一页",
	["#crShiShengTypeChosen"] = "%from 选择了卡牌类型“%arg”，即将使用此卡牌",
	["@crShiSheng"] = "十胜：请为此【%arg】指定必要的目标",
	["~crShiSheng"] = "选择一些目标角色->点击“确定”",
	["#crShiShengGiveUp"] = "%from 原本想发动“十胜”使用一张【%arg】的，不过现在反悔了……",
	["#crShiShengFailed"] = "%from 没能成功发动“十胜”，看来类别 %arg 对其而言难度太高了",
	["@crShiShengMark"] = "致胜",
	["crshishengselect"] = "十胜",
	["crshishenguse"] = "十胜",
	["crshisheng"] = "十胜",
}
--[[****************************************************************
	编号：CCC - 06
	武将：瑶池仙子
	称号：碧水清仙
	势力：神
	性别：女
	体力上限：3勾玉
]]--****************************************************************
YaoChiXianZi = sgs.General(extension, "crYaoChiXianZi", "god", 3, false)
--翻译信息
sgs.LoadTranslationTable{
	["crYaoChiXianZi"] = "瑶池仙子",
	["&crYaoChiXianZi"] = "瑶池仙子",
	["#crYaoChiXianZi"] = "碧水清仙",
	["designer:crYaoChiXianZi"] = "DGAH",
	["cv:crYaoChiXianZi"] = "无",
	["illustrator:crYaoChiXianZi"] = "网络资源",
	["~crYaoChiXianZi"] = "瑶池仙子 的阵亡台词",
}
--[[
	技能：圣洁（锁定技）
	描述：其他角色计算与你的距离时，始终＋X（X为你的体力值且至多为3）。
]]--
ShengJie = sgs.CreateDistanceSkill{
	name = "crShengJie",
	correct_func = function(self, from, to)
		if to:hasSkill("crShengJie") then
			local hp = to:getHp()
			return math.min(hp, 3)
		end
		return 0
	end,
}
--添加技能
YaoChiXianZi:addSkill(ShengJie)
--翻译信息
sgs.LoadTranslationTable{
	["crShengJie"] = "圣洁",
	[":crShengJie"] = "<font color=\"blue\"><b>锁定技</b></font>，其他角色计算与你的距离时，始终＋X（X为你的体力值且至多为3）。",
}
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
--Case01：弃置X张且均为黑桃牌：指定至多X名角色依次失去一点体力，然后各摸一张牌；
XianLingACard = sgs.CreateSkillCard{
	name = "crXianLingACard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		for _,p in ipairs(targets) do
			if p:isAlive() then
				room:loseHp(p, 1)
			end
		end
		for _,p in ipairs(targets) do
			if p:isAlive() then
				room:drawCards(p, 1, "crXianLing")
			end
		end
	end,
}
--Case02：弃置X张且均为红心牌：指定至多X名角色依次回复一点体力，然后各弃一张牌；
XianLingBCard = sgs.CreateSkillCard{
	name = "crXianLingBCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local recover = sgs.RecoverStruct()
		recover.who = source
		recover.recover = 1
		for _,p in ipairs(targets) do
			if p:isAlive() and p:isWounded() then
				room:recover(p, recover)
			end
		end
		for _,p in ipairs(targets) do
			if p:isAlive() and not p:isNude() then
				room:askForDiscard(p, "crXianLing", 1, 1, false, true)
			end
		end	
	end,
}
--Case03：弃置X张且均为草花牌：指定至多X名角色依次进入或解除连环状态；
XianLingCCard = sgs.CreateSkillCard{
	name = "crXianLingCCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local thread = room:getThread()
		for _,p in ipairs(targets) do
			local state = not p:isChained()
			p:setChained(state)
			room:broadcastProperty(p, "chained")
			thread:trigger(sgs.ChainStateChanged, room, p)
		end
	end,
}
--Case04：弃置X张且均为方块牌：指定至多X名角色依次使用一张【杀】，否则你获得其一张牌；
XianLingDCard = sgs.CreateSkillCard{
	name = "crXianLingDCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local prompt = string.format("@crXianLingSlash:%s:", source:objectName())
		for _,p in ipairs(targets) do
			local slash = room:askForUseCard(p, "slash", prompt, -1, sgs.Card_MethodUse, false)
			if not slash then
				if not p:isNude() then
					local id = room:askForCardChosen(source, p, "he", "crXianLing")
					room:obtainCard(source, id)
				end
			end
		end
	end,
}
--Case07：弃置包括X张点数大于10的牌：指定至多X名角色依次将武将牌翻面；
XianLingGCard = sgs.CreateSkillCard{
	name = "crXianLingGCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		for _,p in ipairs(targets) do
			if p:isAlive() then
				p:turnOver()
			end
		end
	end,
}
--Case08：弃置包括X张点数小于4的牌：指定至多X名角色依次受到一点伤害，然后各回复一点体力；
XianLingHCard = sgs.CreateSkillCard{
	name = "crXianLingHCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local damage = sgs.DamageStruct()
		damage.from = nil
		damage.damage = 1
		for _,p in ipairs(targets) do
			if p:isAlive() then
				damage.to = p
				room:damage(damage)
			end
		end
		local recover = sgs.RecoverStruct()
		recover.who = source
		recover.recover = 1
		for _,p in ipairs(targets) do
			if p:isAlive() and p:isWounded() then
				room:recover(p, recover)
			end
		end
	end,
}
--Case09：弃置X张且点数均相连的牌（X至少为2）：指定至多一名角色流失（X-2）点体力上限，然后摸X张牌；
XianLingICard = sgs.CreateSkillCard{
	name = "crXianLingICard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local x = source:getMark("crXianLingData")
		local num = math.max(0, x-2)
		for _,p in ipairs(targets) do
			room:loseMaxHp(p, num)
		end
		for _,p in ipairs(targets) do
			if p:isAlive() then
				room:drawCards(p, x, "crXianLing")
			end
		end
	end,
}
--Case10：弃置X张且点数均相同的牌（X至少为2）：指定至多X名角色按座次轮换手牌；
XianLingJCard = sgs.CreateSkillCard{
	name = "crXianLingJCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local count = #targets
		if count > 1 then
			local moves = sgs.CardsMoveList()
			for index, target in ipairs(targets) do
				local move = sgs.CardsMoveStruct()
				move.card_ids = target:handCards()
				move.from_place = sgs.Player_PlaceHand
				move.to_place = sgs.Player_PlaceHand
				move.from = target
				move.from_player_name = target:objectName()
				if index < count then
					move.to = targets[index+1]
				else
					move.to = targets[1]
				end
				move.to_player_name = move.to:objectName()
				move.reason = sgs.CardMoveReason(
					sgs.CardMoveReason_S_REASON_SWAP, 
					move.from_player_name, 
					move.to_player_name, 
					"crXianLing", 
					""
				)
				moves:append(move)
			end
			for _,move in sgs.qlist(moves) do
				room:moveCardsAtomic(move, false)
			end
		end
	end,
}
--Case11：弃置X张且点数之和为完全平方数：指定至多一名角色，所有其他角色依次获得该角色的一张牌；
XianLingKCard = sgs.CreateSkillCard{
	name = "crXianLingKCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			return not to_select:isNude()
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		for _,victim in ipairs(targets) do
			local others = room:getOtherPlayers(victim)
			for _,p in sgs.qlist(others) do
				if p:isAlive() then
					if victim:isDead() or victim:isNude() then
						break
					end
					local id = room:askForCardChosen(p, victim, "he", "crXianLing")
					if id > 0 then
						room:obtainCard(p, id)
					end
				end
			end
		end
	end,
}
--Case12：弃置四种花色的牌各至少一张：指定至多一名角色失去一项技能；
XianLingLCard = sgs.CreateSkillCard{
	name = "crXianLingLCard",
	--skill_name = "crXianLing",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local count = sgs.Self:getMark("crXianLingCount")
		if #targets < count then
			local skills = to_select:getVisibleSkillList()
			for _,skill in sgs.qlist(skills) do
				if skill:isAttachedLordSkill() then
				elseif skill:inherits("SPConvertSkill") then
				elseif skill:isLordSkill() then
					if to_select:hasLordSkill(skill:objectName()) then
						return true
					end
				else
					return true
				end
			end
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		for _,p in ipairs(targets) do
			local skills = p:getVisibleSkillList()
			local choices = {}
			for _,skill in sgs.qlist(skills) do
				if skill:isAttachedLordSkill() then
				elseif skill:inherits("SPConvertSkill") then
				elseif skill:isLordSkill() then
					if p:hasLordSkill(skill:objectName()) then
						table.insert(choices, skill:objectName())
					end
				else
					table.insert(choices, skill:objectName())
				end
			end
			if #choices > 0 then
				choices = table.concat(choices, "+")
				local ai_data = sgs.QVariant()
				ai_data:setValue(p)
				source:setTag("crXianLingLTarget", ai_data) --For AI
				local choice = room:askForChoice(source, "crXianLing", choices, ai_data)
				source:removeTag("crXianLingLTarget") --For AI
				room:handleAcquireDetachSkills(p, "-"..choice)
			end
		end
	end,
}
XianLingCard = sgs.CreateSkillCard{
	name = "crXianLingCard",
	--skill_name = "crXianLing",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_use = function(self, room, source, targets)
		local subcards = self:getSubcards()
		local count = subcards:length()
		local spade, heart, club, diamond = 0, 0, 0, 0
		local big, small = 0, 0
		local points = {}
		local same = true
		local sum = 0
		for index, id in sgs.qlist(subcards) do
			local card = sgs.Sanguosha:getCard(id)
			local suit = card:getSuit()
			if suit == sgs.Card_Spade then
				spade = spade + 1
			elseif suit == sgs.Card_Heart then
				heart = heart + 1
			elseif suit == sgs.Card_Club then
				club = club + 1
			elseif suit == sgs.Card_Diamond then
				diamond = diamond + 1
			end
			local point = card:getNumber()
			sum = sum + point
			if point > 10 then
				big = big + 1
			elseif point < 4 then
				small = small + 1
			end
			table.insert(points, point)
			if same then
				same = ( ( index + 1 ) * point == sum )
			end
		end
		--Case01：弃置X张且均为黑桃牌：指定至多X名角色依次失去一点体力，然后各摸一张牌；
		if spade > 0 and heart == 0 and club == 0 and diamond == 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case01"
			msg.from = source
			msg.arg = spade
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 1)
			room:setPlayerMark(source, "crXianLingCount", spade)
			local prompt = string.format("@crXianLingA:::%d:", spade)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case02：弃置X张且均为红心牌：指定至多X名角色依次回复一点体力，然后各弃一张牌；
		if spade == 0 and heart > 0 and club == 0 and diamond == 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case02"
			msg.from = source
			msg.arg = heart
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 2)
			room:setPlayerMark(source, "crXianLingCount", heart)
			local prompt = string.format("@crXianLingB:::%d:", heart)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case03：弃置X张且均为草花牌：指定至多X名角色依次进入或解除连环状态；
		if spade == 0 and heart == 0 and club > 0 and diamond == 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case03"
			msg.from = source
			msg.arg = club
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 3)
			room:setPlayerMark(source, "crXianLingCount", club)
			local prompt = string.format("@crXianLingC:::%d:", club)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case04：弃置X张且均为方块牌：指定至多X名角色依次使用一张【杀】，否则你获得其一张牌；
		if spade == 0 and heart == 0 and club == 0 and diamond > 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case04"
			msg.from = source
			msg.arg = diamond
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 4)
			room:setPlayerMark(source, "crXianLingCount", diamond)
			local prompt = string.format("@crXianLingD:::%d:", diamond)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case05：弃置包括X张黑色牌（X至少为3）：视为你使用了一张【南蛮入侵】，且该【南蛮入侵】造成雷电属性的伤害；
		if spade + club >= 3 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case05"
			msg.from = source
			msg.arg = spade + club
			room:sendLog(msg) --发送提示信息
			if source:askForSkillInvoke("crXianLingE", sgs.QVariant("invoke")) then
				local sa = sgs.Sanguosha:cloneCard("savage_assault", sgs.Card_NoSuit, 0)
				sa:setSkillName("crXianLingE")
				local use = sgs.CardUseStruct()
				use.from = source
				use.card = sa
				room:useCard(use, false)
			end
		end
		--Case06：弃置包括X张红色牌（X至少为3）：视为你使用了一张【万箭齐发】，且该【万箭齐发】造成火焰属性的伤害；
		if heart + diamond >= 3 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case06"
			msg.from = source
			msg.arg = heart + diamond
			room:sendLog(msg) --发送提示信息
			if source:askForSkillInvoke("crXianLingF", sgs.QVariant("invoke")) then
				local aa = sgs.Sanguosha:cloneCard("archery_attack", sgs.Card_NoSuit, 0)
				aa:setSkillName("crXianLingF")
				local use = sgs.CardUseStruct()
				use.from = source
				use.card = aa
				room:useCard(use, false)
			end
		end
		--Case07：弃置包括X张点数大于10的牌：指定至多X名角色依次将武将牌翻面；
		if big > 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case07"
			msg.from = source
			msg.arg = big
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 7)
			room:setPlayerMark(source, "crXianLingCount", big)
			local prompt = string.format("@crXianLingG:::%d:", big)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case08：弃置包括X张点数小于4的牌：指定至多X名角色依次受到一点伤害，然后各回复一点体力；
		if small > 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case08"
			msg.from = source
			msg.arg = small
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 8)
			room:setPlayerMark(source, "crXianLingCount", small)
			local prompt = string.format("@crXianLingH:::%d:", small)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case09：弃置X张且点数均相连的牌（X至少为2）：指定至多一名角色流失（X-2）点体力上限，然后摸X张牌；
		if count >= 2 then
			local compare_func = function(a, b) --排序函数
				return a < b
			end
			table.sort(points, compare_func) --对所有子卡点数按从小到大的顺序排序
			local flag = true --点数均相连的标志
			local former = nil --上一个经检测的点数
			for _,point in ipairs(points) do
				if not former then
					former = point --记录为上一个检测过的点数
				else
					local delt = point - former --当前点数与上一个点数的差距
					if delt == 1 then --差距为1：目前点数还是相连的
						former = point --记录为上一个检测过的点数
					else --差距不为1：确定点数不相连
						flag = false
						break 
					end
				end
			end
			if flag then
				local msg = sgs.LogMessage()
				msg.type = "#crXianLing_Case09"
				msg.from = source
				msg.arg = count
				msg.arg2 = count - 2
				room:sendLog(msg) --发送提示信息
				room:setPlayerMark(source, "crXianLingType", 9)
				room:setPlayerMark(source, "crXianLingCount", 1)
				room:setPlayerMark(source, "crXianLingData", count)
				local prompt = string.format("@crXianLingI:::%d:%d", count-2, count)
				room:askForUseCard(source, "@@crXianLing", prompt)
				room:setPlayerMark(source, "crXianLingData", 0)
			end
		end
		--Case10：弃置X张且点数均相同的牌（X至少为2）：指定至多X名角色按座次轮换手牌；
		if count >= 2 and same then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case10"
			msg.from = source
			msg.arg = count
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 10)
			room:setPlayerMark(source, "crXianLingCount", count)
			local prompt = string.format("@crXianLingJ:::%d:", count)
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		--Case11：弃置X张且点数之和为完全平方数：指定至多一名角色，所有其他角色依次获得该角色的一张牌；
		if sum > 0 then
			local flag = false
			for i=1, sum, 1 do
				local result = i * i
				if result == sum then
					flag = true
					break
				elseif result > sum then
					break
				end
			end
			if flag then
				local msg = sgs.LogMessage()
				msg.type = "#crXianLing_Case11"
				msg.from = source
				msg.arg = count
				msg.arg2 = sum
				room:sendLog(msg) --发送提示信息
				room:setPlayerMark(source, "crXianLingType", 11)
				room:setPlayerMark(source, "crXianLingCount", 1)
				local prompt = string.format("@crXianLingK:::%d:", count)
				room:askForUseCard(source, "@@crXianLing", prompt)
			end
		end
		--Case12：弃置四种花色的牌各至少一张：指定至多一名角色失去一项技能；
		if spade > 0 and heart > 0 and club > 0 and diamond > 0 then
			local msg = sgs.LogMessage()
			msg.type = "#crXianLing_Case12"
			msg.from = source
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(source, "crXianLingType", 12)
			room:setPlayerMark(source, "crXianLingCount", 1)
			local prompt = string.format("@crXianLingL")
			room:askForUseCard(source, "@@crXianLing", prompt)
		end
		room:setPlayerMark(source, "crXianLingType", 0)
		room:setPlayerMark(source, "crXianLingCount", 0)
	end,
}
XianLingVS = sgs.CreateViewAsSkill{
	name = "crXianLing",
	n = 999,
	view_filter = function(self, selected, to_select)
		return true
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = XianLingCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		else
			local case = sgs.Self:getMark("crXianLingType")
			if case == 1 then
				return XianLingACard:clone()
			elseif case == 2 then
				return XianLingBCard:clone()
			elseif case == 3 then
				return XianLingCCard:clone()
			elseif case == 4 then
				return XianLingDCard:clone()
			elseif case == 7 then
				return XianLingGCard:clone()
			elseif case == 8 then
				return XianLingHCard:clone()
			elseif case == 9 then
				return XianLingICard:clone()
			elseif case == 10 then
				return XianLingJCard:clone()
			elseif case == 11 then
				return XianLingKCard:clone()
			elseif case == 12 then
				return XianLingLCard:clone()
			end
		end
	end,
	enabled_at_play = function(self, player)
		if player:isNude() then
			return false
		elseif player:hasUsed("#crXianLingCard") then
			return false
		end
		return true
	end,
	enabled_at_response = function(self, player, pattern)
		return pattern == "@@crXianLing"
	end,
}
XianLing = sgs.CreateTriggerSkill{
	name = "crXianLing",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageCaused},
	view_as_skill = XianLingVS,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		local aoe = damage.card
		if aoe then
			local skillname = aoe:getSkillName()
			if skillname == "crXianLingE" then
				damage.nature = sgs.DamageStruct_Thunder
				data:setValue(damage)
			elseif skillname == "crXianLingF" then
				damage.nature = sgs.DamageStruct_Fire
				data:setValue(damage)
			end
		end
		return false
	end,
}
--添加技能
YaoChiXianZi:addSkill(XianLing)
--翻译信息
sgs.LoadTranslationTable{
	["crXianLing"] = "弦灵",
	[":crXianLing"] = "<font color=\"green\"><b>阶段技</b></font>，你可以弃置至少一张牌，然后根据这些牌的特征依次执行相应的效果。\
1、弃置X张且均为<b>黑</b><b>桃</b>牌：指定至多X名角色依次失去一点体力，然后各摸一张牌；\
2、弃置X张且均为<b>红</b><b>心</b>牌：指定至多X名角色依次回复一点体力，然后各弃一张牌；\
3、弃置X张且均为<b>草</b><b>花</b>牌：指定至多X名角色依次进入或解除连环状态；\
4、弃置X张且均为<b>方</b><b>块</b>牌：指定至多X名角色依次使用一张【杀】，否则你获得其一张牌；\
5、弃置包括X张<b>黑</b><b>色</b>牌（X至少为3）：视为你使用了一张【南蛮入侵】，且该【南蛮入侵】造成雷电属性的伤害；\
6、弃置包括X张<b>红</b><b>色</b>牌（X至少为3）：视为你使用了一张【万箭齐发】，且该【万箭齐发】造成火焰属性的伤害；\
7、弃置包括X张点数大于10的牌：指定至多X名角色依次将武将牌翻面；\
8、弃置包括X张点数小于4的牌：指定至多X名角色依次受到一点伤害，然后各回复一点体力；\
9、弃置X张且点数均相连的牌（X至少为2）：指定至多一名角色流失（X-2）点体力上限，然后摸X张牌；\
10、弃置X张且点数均相同的牌（X至少为2）：指定至多X名角色按座次轮换手牌；\
11、弃置X张且点数之和为完全平方数：指定至多一名角色，所有其他角色依次获得该角色的一张牌；\
12、弃置四种花色的牌各至少一张：指定至多一名角色失去一项技能。",
	["@crXianLingA"] = "弦灵01：您可以选择至多 %arg 名角色，令其失去1点体力，然后摸一张牌",
	["@crXianLingB"] = "弦灵02：您可以选择至多 %arg 名角色，令其回复1点体力，然后弃一张牌",
	["@crXianLingC"] = "弦灵03：您可以选择至多 %arg 名角色，令其进入或解除连环状态",
	["@crXianLingD"] = "弦灵04：您可以选择至多 %arg 名角色，令其使用一张【杀】，否则你获得其一张牌",
	["@crXianLingSlash"] = "弦灵04：请使用一张【杀】，否则 %src 将获得你的一张牌",
	["crXianLingE"] = "弦灵05",
	["crXianLingE:invoke"] = "弦灵05：您可以视为使用一张【南蛮入侵】，且该【南蛮入侵】造成雷电属性的伤害",
	["crXianLingF"] = "弦灵06",
	["crXianLingF:invoke"] = "弦灵06：您可以视为使用一张【万箭齐发】，且该【万箭齐发】造成火焰属性的伤害",
	["~crXianLing"] = "选择一些目标角色（包括自己）->点击“确定”",
	["@crXianLingG"] = "弦灵07：您可以选择至多 %arg 名角色，令其翻面",
	["@crXianLingH"] = "弦灵08：您可以选择至多 %arg 名角色，令其受到1点伤害，然后回复1点体力",
	["@crXianLingI"] = "弦灵09：您可以选择至多 1 名角色，令其失去 %arg 点体力上限，然后摸 %arg2 张牌",
	["@crXianLingJ"] = "弦灵10：您可以选择至多 %arg 名角色，令这些角色按座次轮换手牌",
	["@crXianLingK"] = "弦灵11：您可以选择至多 1 名角色，令其他角色依次获得该角色的一张牌",
	["@crXianLingL"] = "弦灵12：您可以选择至多 1 名角色，令其失去一项技能",
	["#crXianLing_Case01"] = "%from 发动“弦灵”弃置了 %arg 张花色均为黑桃的牌，可以令至多 %arg 名角色失去 1 点体力并摸一张牌",
	["#crXianLing_Case02"] = "%from 发动“弦灵”弃置了 %arg 张花色均为红心的牌，可以令至多 %arg 名角色回复 1 点体力并弃一张牌",
	["#crXianLing_Case03"] = "%from 发动“弦灵”弃置了 %arg 张花色均为草花的牌，可以令至多 %arg 名角色进入或解除连环状态",
	["#crXianLing_Case04"] = "%from 发动“弦灵”弃置了 %arg 张花色均为方块的牌，可以令至多 %arg 名角色依次使用一张【杀】",
	["#crXianLing_Case05"] = "%from 发动“弦灵”弃置了 %arg 张黑色牌，可以视为使用一张将造成雷电伤害的【南蛮入侵】",
	["#crXianLing_Case06"] = "%from 发动“弦灵”弃置了 %arg 张红色牌，可以视为使用一张将造成火焰伤害的【万箭齐发】",
	["#crXianLing_Case07"] = "%from 发动“弦灵”弃置了 %arg 张点数大于 10 的牌，可以令至多 %arg 名角色翻面",
	["#crXianLing_Case08"] = "%from 发动“弦灵”弃置了 %arg 张点数小于 4 的牌，可以令至多 %arg 名角色各受到1点伤害再回复1点体力",
	["#crXianLing_Case09"] = "%from 发动“弦灵”弃置了 %arg 张点数均相连的牌，可以令至多 1 名角色失去 %arg2 点体力上限并摸 %arg 张牌",
	["#crXianLing_Case10"] = "%from 发动“弦灵”弃置了 %arg 张点数均相同的牌，可以令至多 %arg 名角色按座次轮换手牌",
	["#crXianLing_Case11"] = "%from 发动“弦灵”弃置了 %arg 张点数之和为 %arg2 的牌，可以指定至多 1 名角色，令其他角色依次获得其一张牌",
	["#crXianLing_Case12"] = "%from 发动“弦灵”弃置了四种花色各至少一张牌，可以指定至多 1 名角色失去一项技能",
	["crxianlinga"] = "弦灵01",
	["crxianlingb"] = "弦灵02",
	["crxianlingc"] = "弦灵03",
	["crxianlingd"] = "弦灵04",
	["crxianlingg"] = "弦灵07",
	["crxianlingh"] = "弦灵08",
	["crxianlingi"] = "弦灵09",
	["crxianlingj"] = "弦灵10",
	["crxianlingk"] = "弦灵11",
	["crxianlingl"] = "弦灵12",
	["crxianling"] = "弦灵",
}
--[[
	技能：水碧
	描述：你攻击范围内的一名其他角色濒死时，若你的武将牌正面朝上，你可以令该角色获得一枚“水碧”标记，然后你翻面并失去2点体力，令该角色回复所有体力。
		锁定技，杀死你的角色获得技能“水寒”。
		你死亡时，你可以指定一名拥有“水碧”标记的角色，该角色增加1点体力上限、回复1点体力并摸一张牌，然后其获得技能“梦归”。
]]--
ShuiBi = sgs.CreateTriggerSkill{
	name = "crShuiBi",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Dying, sgs.Death},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.Dying then
			local dying = data:toDying()
			local victim = dying.who
			if victim and victim:objectName() == player:objectName() then
				local others = room:getOtherPlayers(player)
				for _,source in sgs.qlist(others) do
					if source:hasSkill("crShuiBi") and source:faceUp() then
						if source:inMyAttackRange(victim) then
							if source:askForSkillInvoke("crShuiBi", data) then
								room:broadcastSkillInvoke("crShuiBi") --播放配音
								room:notifySkillInvoked(source, "crShuiBi") --显示技能发动
								victim:gainMark("@crShuiBiMark", 1)
								source:turnOver()
								room:loseHp(source, 2)
								local count = math.max( 0, victim:getMaxHp() - victim:getHp() )
								if count > 0 then
									local recover = sgs.RecoverStruct()
									recover.who = source
									recover.recover = count
									room:recover(victim, recover)
								end
								return false
							end
						end
					end
				end
			end
		elseif event == sgs.Death then
			local death = data:toDeath()
			local victim = death.who
			if victim and victim:objectName() == player:objectName() then
				if victim:hasSkill("crShuiBi") then
					local reason = death.damage
					if reason then
						local killer = reason.from
						if killer and killer:isAlive() then
							room:broadcastSkillInvoke("crShuiBi") --播放配音
							room:notifySkillInvoked(player, "crShuiBi") --显示技能发动
							room:handleAcquireDetachSkills(killer, "crShuiHan")
						end
					end
					local alives = room:getAlivePlayers()
					local targets = sgs.SPlayerList()
					for _,p in sgs.qlist(alives) do
						if p:getMark("@crShuiBiMark") > 0 then
							targets:append(p)
						end
					end
					if not targets:isEmpty() then
						local target = room:askForPlayerChosen(player, targets, "crShuiBi", "@crShuiBi", true)
						if target then
							local maxhp = target:getMaxHp() + 1
							room:setPlayerProperty(target, "maxhp", sgs.QVariant(maxhp))
							local recover = sgs.RecoverStruct()
							recover.who = player
							recover.recover = 1
							room:recover(target, recover)
							room:drawCards(target, 1, "crShuiBi")
							room:handleAcquireDetachSkills(target, "crMengGui")
						end
					end
				end
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end,
}
--添加技能
YaoChiXianZi:addSkill(ShuiBi)
--翻译信息
sgs.LoadTranslationTable{
	["crShuiBi"] = "水碧",
	[":crShuiBi"] = "你攻击范围内的一名其他角色濒死时，若你的武将牌正面朝上，你可以令该角色获得一枚“水碧”标记，然后你翻面并失去2点体力，令该角色回复所有体力。\
<font color=\"blue\"><b>锁定技</b></font>，杀死你的角色获得技能“水寒”。\
你死亡时，你可以指定一名拥有“水碧”标记的角色，该角色增加1点体力上限、回复1点体力并摸一张牌，然后其获得技能“梦归”。\
\
★<b>水寒</b>: <b><font color=\"blue\">锁定技</font></b>，准备阶段开始时，你须弃置一张方块牌，否则你失去1点体力。\
\
★<b>梦归</b>: 你即将受到伤害时，你可以弃一枚“水碧”标记并摸两张牌，防止此伤害。",
	["@crShuiBi"] = "水碧：您可以令一名拥有“水碧”标记的角色增加1点体力上限、回复1点体力、摸一张牌，并获得技能“梦归”",
	["@crShuiBiMark"] = "水碧",
}
--[[
	技能：水寒（锁定技）
	描述：准备阶段开始时，你须弃置一张方块牌，否则你失去1点体力。
]]--
ShuiHan = sgs.CreateTriggerSkill{
	name = "crShuiHan",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.EventPhaseStart},
	on_trigger = function(self, event, player, data)
		if player:getPhase() == sgs.Player_Start then
			local room = player:getRoom()
			room:broadcastSkillInvoke("crShuiHan") --播放配音
			room:sendCompulsoryTriggerLog(player, "crShuiHan", false) --发送提示信息
			room:notifySkillInvoked(player, "crShuiHan") --显示技能发动
			local diamond = room:askForCard(
				player, ".|diamond", "@crShuiHan", sgs.QVariant(), sgs.Card_MethodDiscard, nil, false, "crShuiHan", true
			)
			if not diamond then
				room:loseHp(player, 1)
			end
		end
		return false
	end,
}
--添加技能
AnJiang:addSkill(ShuiHan)
YaoChiXianZi:addRelateSkill("crShuiHan")
--翻译信息
sgs.LoadTranslationTable{
	["crShuiHan"] = "水寒",
	[":crShuiHan"] = "<font color=\"blue\"><b>锁定技</b></font>, 准备阶段开始时，你须弃置一张方块牌，否则你失去1点体力。",
	["@crShuiHan"] = "水寒：请弃一张方块牌（包括装备），否则你将失去1点体力",
}
--[[
	技能：梦归
	描述：你即将受到伤害时，你可以弃一枚“水碧”标记并摸两张牌，防止此伤害。
]]--
MengGui = sgs.CreateTriggerSkill{
	name = "crMengGui",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		local victim = damage.to
		if victim and victim:objectName() == player:objectName() then
			if victim:askForSkillInvoke("crMengGui", data) then
				room:broadcastSkillInvoke("crMengGui") --播放配音
				room:notifySkillInvoked(player, "crMengGui") --显示技能发动
				room:doLightbox("$crMengGuiAnimate") --显示全屏信息特效
				player:loseMark("@crShuiBiMark", 1)
				room:drawCards(player, 2, "crMengGui")
				return true
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		if target and target:getMark("@crShuiBiMark") > 0 then
			if target:hasSkill("crMengGui") and target:isAlive() then
				return true
			end
		end
		return false
	end,
}
--添加技能
AnJiang:addSkill(MengGui)
YaoChiXianZi:addRelateSkill("crMengGui")
--翻译信息
sgs.LoadTranslationTable{
	["crMengGui"] = "梦归",
	[":crMengGui"] = "你即将受到伤害时，你可以弃一枚“水碧”标记并摸两张牌，防止此伤害。",
	["$crMengGuiAnimate"] = "难忘君情，瑶池梦归",
}
--[[****************************************************************
	编号：CCC - 07
	武将：南华老仙（隐藏武将）
	称号：黄天的指引者
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
NanHua = sgs.General(extension, "crNanHuaLaoXian", "god", 3, true, true)
--翻译信息
sgs.LoadTranslationTable{
	["crNanHuaLaoXian"] = "南华老仙",
	["&crNanHuaLaoXian"] = "南华老仙",
	["#crNanHuaLaoXian"] = "黄天的指引者",
	["designer:crNanHuaLaoXian"] = "clarkcyt",
	["cv:crNanHuaLaoXian"] = "无",
	["illustrator:crNanHuaLaoXian"] = "网络资源",
	["~crNanHuaLaoXian"] = "南华老仙 的阵亡台词",
}
--[[
	技能：移魂（阶段技）
	描述：你可以指定两名体力不同的其他角色，交换他们的体力牌。若这两名角色的体力值之差大于1，你回复1点体力。
]]--
YiHunCard = sgs.CreateSkillCard{
	name = "crYiHunCard",
	--skill_name = "crYiHun",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		if to_select:objectName() == sgs.Self:objectName() then
			return false
		elseif #targets == 0 then
			return true
		elseif #targets == 1 then
			return targets[1]:getHp() ~= to_select:getHp()
		end
		return false
	end,
	feasible = function(self, targets)
		return #targets == 2
	end,
	on_use = function(self, room, source, targets)
		room:broadcastSkillInvoke("crYiHun", 1) --播放配音
		local playerA, playerB = targets[1], targets[2]
		local hpA, hpB = playerA:getHp(), playerB:getHp()
		local maxhpA, maxhpB = playerA:getMaxHp(), playerB:getMaxHp()
		if maxhpA ~= maxhpB then
			room:setPlayerProperty(playerA, "maxhp", sgs.QVariant(maxhpB))
			room:setPlayerProperty(playerB, "maxhp", sgs.QVariant(maxhpA))
		end
		room:setPlayerProperty(playerA, "hp", sgs.QVariant(hpB))
		room:setPlayerProperty(playerB, "hp", sgs.QVariant(hpA))
		local msg = sgs.LogMessage()
		msg.type = "#crYiHun"
		msg.from = source
		msg.to:append(playerA)
		msg.to:append(playerB)
		room:sendLog(msg) --发送提示信息
		if math.abs(hpA - hpB) > 1 then
			if source:isAlive() and source:isWounded() then
				room:broadcastSkillInvoke("crYiHun", 2) --播放配音
				local recover = sgs.RecoverStruct()
				recover.who = source
				recover.recover = 1
				room:recover(source, recover)
			end
		end
	end,
}
YiHun = sgs.CreateViewAsSkill{
	name = "crYiHun",
	n = 0,
	view_as = function(self, cards)
		return YiHunCard:clone()
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#crYiHunCard")
	end,
}
--添加技能
NanHua:addSkill(YiHun)
--翻译信息
sgs.LoadTranslationTable{
	["crYiHun"] = "移魂",
	[":crYiHun"] = "<font color=\"green\"><b>阶段技</b></font>，你可以指定两名体力不同的其他角色，交换他们的体力牌。若这两名角色的体力值之差大于1，你回复1点体力。",
	["$crYiHun1"] = "技能 移魂 交换体力时 的台词",
	["$crYiHun2"] = "技能 移魂 回复体力时 的台词",
	["#crYiHun"] = "%from 交换了 %to 的体力牌",
	["cryihun"] = "移魂",
}
--[[
	技能：出世（锁定技）
	描述：你即将受到伤害时，你防止此伤害并失去1点体力。
]]--
ChuShi = sgs.CreateTriggerSkill{
	name = "crChuShi",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageInflicted},
	on_trigger = function(self, event, player, data)
		local damage = data:toDamage()
		local victim = damage.to
		if victim and victim:objectName() == player:objectName() then
			local room = player:getRoom()
			room:broadcastSkillInvoke("crChuShi") --播放配音
			room:sendCompulsoryTriggerLog(player, "crChuShi", false) --发送提示信息
			room:notifySkillInvoked(player, "crChuShi") --显示技能发动
			local msg = sgs.LogMessage()
			msg.type = "#crChuShi"
			msg.from = player
			msg.arg = "crChuShi"
			room:sendLog(msg) --发送提示信息
			room:loseHp(player, 1)
			return true
		end
		return false
	end,
}
--添加技能
NanHua:addSkill(ChuShi)
--翻译信息
sgs.LoadTranslationTable{
	["crChuShi"] = "出世",
	[":crChuShi"] = "<font color=\"blue\"><b>锁定技</b></font>，你即将受到伤害时，你防止此伤害并失去1点体力。",
	["$crChuShi"] = "技能 出世 的台词",
	["#crChuShi"] = "%from 的技能“%arg”被触发，防止了本次伤害",
}
--[[
	技能：噬魂
	描述：当你进入濒死状态时，若你的武将牌正面朝上，你可以选择一名角色并将你的武将牌翻面，你回复X点体力，然后该角色失去Y点体力。（X为该角色的体力值，Y为你的体力上限与X之间的较大者）
]]--
ShiHun = sgs.CreateTriggerSkill{
	name = "crShiHun",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.EnterDying},
	on_trigger = function(self, event, player, data)
		local dying = data:toDying()
		local victim = dying.who
		if victim and victim:objectName() == player:objectName() then
			if player:faceUp() then
				local room = player:getRoom()
				local alives = room:getAlivePlayers()
				local target = room:askForPlayerChosen(player, alives, "crShiHun", "@crShiHun", true, true)
				if target then
					room:broadcastSkillInvoke("crShiHun") --播放配音
					room:notifySkillInvoked(player, "crShiHun") --显示技能发动
					player:turnOver()
					local x = target:getHp()
					if x > 0 then
						local recover = sgs.RecoverStruct()
						recover.who = player
						recover.recover = x
						room:recover(player, recover)
					end
					local maxhp = player:getMaxHp()
					local y = math.max(x, maxhp)
					if y > 0 then
						room:loseHp(target, y)
					end
				end
			end
		end
		return false
	end,
}
--添加技能
NanHua:addSkill(ShiHun)
--翻译信息
sgs.LoadTranslationTable{
	["crShiHun"] = "噬魂",
	[":crShiHun"] = "当你进入濒死状态时，若你的武将牌正面朝上，你可以选择一名角色并将你的武将牌翻面，你回复X点体力，然后该角色失去Y点体力。（X为该角色的体力值，Y为你的体力上限与X之间的较大者）",
	["$crShiHun"] = "技能 噬魂 的台词",
	["@crShiHun"] = "您可以发动“噬魂”选择一名角色",
}
--[[****************************************************************
	编号：CCC - 08
	武将：掀桌于吉（隐藏武将）
	称号：有无相生
	势力：神
	性别：男
	体力上限：3勾玉
]]--****************************************************************
YuJi = sgs.General(extension, "crYuJi", "god", 3, true, true)
--翻译信息
sgs.LoadTranslationTable{
	["crYuJi"] = "掀桌于吉",
	["&crYuJi"] = "于吉",
	["#crYuJi"] = "有无相生",
	["designer:crYuJi"] = "DGAH",
	["cv:crYuJi"] = "七哥",
	["illustrator:crYuJi"] = "LiuHeng",
	["~crYuJi"] = "魂飞魄散，回天无术……",
}
--[[
	技能：幻惑
	描述：当你需要使用或打出一张基本牌或非延时性锦囊牌时，你可以视为使用或打出了该牌。 
]]--
function toCard(name)
	local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
	card:deleteLater()
	return card
end
function getResponseChoices(room, source, pattern)
	local choices = {}
	local manFlag, kofFlag = true, true
	local banPackages = sgs.Sanguosha:getBanPackages()
	for _,ban in ipairs(banPackages) do
		if ban == "maneuvering" then
			manFlag = false
		elseif ban == "New1v1Card" then
			kofFlag = false
		end
	end
	local names = {
		"slash", "jink", "peach", 
		"god_salvation", "amazing_grace", "savage_assault", "archery_attack", 
		"collateral", "dismantlement", "snatch", "ex_nihilo", "duel", "nullification"
	}
	if manFlag then
		table.insert(names, "fire_slash")
		table.insert(names, "thunder_slash")
		table.insert(names, "analeptic")
		table.insert(names, "fire_attack")
		table.insert(names, "iron_chain")
	end
	if kofFlag then
		table.insert(names, "drowning")
	end
	for _,name in ipairs(names) do
		local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
		if card then
			
			if card:match(pattern) then
				table.insert(choices, name)
			end
		end
	end
	return choices
end
function getUseChoices(room, source)
	local choices = {}
	local manFlag, kofFlag = true, true
	local banPackages = sgs.Sanguosha:getBanPackages()
	for _,ban in ipairs(banPackages) do
		if ban == "maneuvering" then
			manFlag = false
		elseif ban == "New1v1Card" then
			kofFlag = false
		end
	end
	local alives = room:getAlivePlayers()
	local others = room:getOtherPlayers(source)
	local selected = sgs.PlayerList()
	--杀
	local card = toCard("slash")
	if sgs.Slash_IsAvailable(source) then
		for _,p in sgs.qlist(others) do
			if source:canSlash(p, card) then
				table.insert(choices, "slash")
				if manFlag then
					--火杀
					table.insert(choices, "fire_slash")
					--雷杀
					table.insert(choices, "thunder_slash")
				end
				break
			end
		end
	end
	--桃
	if source:isWounded() then
		if not source:hasFlag("Global_PreventPeach") then
			card = toCard("peach")
			if not source:isProhibited(source, card) then
				table.insert(choices, "peach")
			end
		end
	end
	--酒
	if manFlag then
		if sgs.Analeptic_IsAvailable(source) then
			local card = toCard("analeptic")
			if not source:isProhibited(source, card) then
				table.insert(choices, "analeptic")
			end
		end
	end
	--桃园结义
	local card = toCard("god_salvation")
	for _,p in sgs.qlist(alives) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "god_salvation")
			break
		end
	end
	--五谷丰登
	local card = toCard("amazing_grace")
	for _,p in sgs.qlist(alives) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "amazing_grace")
			break
		end
	end
	--南蛮入侵
	local card = toCard("savage_assault")
	for _,p in sgs.qlist(others) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "savage_assault")
			break
		end
	end
	--万箭齐发
	local card = toCard("archery_attack")
	for _,p in sgs.qlist(others) do
		if not p:isProhibited(source, card) then
			table.insert(choices, "archery_attack")
			break
		end
	end
	--借刀杀人
	local card = toCard("collateral")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "collateral")
			break
		end
	end
	--顺手牵羊
	local card = toCard("snatch")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "snatch")
			break
		end
	end
	--过河拆桥
	local card = toCard("dismantlement")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "dismantlement")
			break
		end
	end
	--铁索连环
	if manFlag then
		card = toCard("iron_chain")
		if card:canRecast() then
			table.insert(choices, "iron_chain")
		else
			for _,p in sgs.qlist(alives) do
				if card:targetFilter(selected, p, source) then
					table.insert(choices, "iron_chain")
					break
				end
			end
		end
	end
	--无中生有
	card = toCard("ex_nihilo")
	if not source:isProhibited(source, card) then
		table.insert(choices, "ex_nihilo")
	end
	--水淹七军
	if kofFlag then
		card = toCard("drowning")
		for _,p in sgs.qlist(alives) do
			if card:targetFilter(selected, p, source) then
				table.insert(choices, "drowning")
				break
			end
		end
	end
	--火攻
	if manFlag then
		card = toCard("fire_attack")
		for _,p in sgs.qlist(alives) do
			if card:targetFilter(selected, p, source) then
				table.insert(choices, "fire_attack")
				break
			end
		end
	end
	--决斗
	card = toCard("duel")
	for _,p in sgs.qlist(others) do
		if card:targetFilter(selected, p, source) then
			table.insert(choices, "duel")
			break
		end
	end
	return choices
end
function getHHCard(player)
	local name = player:property("crHuanHuoType"):toString() or ""
	local card = sgs.Sanguosha:cloneCard(name, sgs.Card_NoSuit, 0)
	card:setSkillName("crHuanHuo")
	return card
end
HuanHuoSelectCard = sgs.CreateSkillCard{
	name = "crHuanHuoSelectCard",
	--skill_name = "crHuanHuo",
	target_fixed = false,
	will_throw = true,
	mute = true,
	filter = function(self, targets, to_select)
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		local card = getHHCard(sgs.Self)
		return card:targetFilter(selected, to_select, sgs.Self)
	end,
	feasible = function(self, targets)
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		local card = getHHCard(sgs.Self)
		return card:targetsFeasible(selected, sgs.Self)
	end,
	about_to_use = function(self, room, use)
		if not use.to:isEmpty() then
			local target = use.to:first()
			room:setPlayerFlag(target, "crHuanHuoFirstTarget")
		end
		self:cardOnUse(room, use)
	end,
	on_use = function(self, room, source, targets)
		local card = getHHCard(source)
		room:setPlayerProperty(source, "crHuanHuoType", sgs.QVariant(""))
		room:setPlayerFlag(source, "-crHuanHuoSelect")
		local first, pos = nil, nil
		for index, target in ipairs(targets) do
			if target:hasFlag("crHuanHuoFirstTarget") then
				first = target
				pos = index
			end
		end
		local use = sgs.CardUseStruct()
		use.from = source
		use.card = card
		if first and card:isKindOf("Collateral") then
			use.to:append(first)
			table.remove(targets, pos)
		end
		for _,target in ipairs(targets) do
			use.to:append(target)
		end
		room:useCard(use, true)
	end
}
HuanHuoCard = sgs.CreateSkillCard{
	name = "crHuanHuoCard",
	--skill_name = "crHuanHuo",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_validate = function(self, use)
		local user = use.from
		local room = user:getRoom()
		local pattern = self:getUserString()
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		local choices = {}
		local is_use = false
		if reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE_USE then
			choices = getResponseChoices(room, user, pattern)
		elseif reason == sgs.CardUseStruct_CARD_USE_REASON_PLAY then
			choices = getUseChoices(room, user)
			is_use = true
		end
		if #choices == 0 then
			return nil
		end
		choices = table.concat(choices, "+")
		local choice = room:askForChoice(user, "crHuanHuo", choices, sgs.QVariant(is_use))
		local card = sgs.Sanguosha:cloneCard(choice, sgs.Card_NoSuit, 0)
		if card:targetFixed() then
			card:setSkillName("crHuanHuo")
			return card
		end
		room:setPlayerFlag(user, "crHuanHuoSelect")
		room:setPlayerProperty(user, "crHuanHuoType", sgs.QVariant(choice))
		local prompt = string.format("@crHuanHuo:::%s:", choice)
		local success = room:askForUseCard(user, "@@crHuanHuo", prompt)
		if not success then
			room:setPlayerProperty(user, "crHuanHuoType", sgs.QVariant(""))
			room:setPlayerFlag(user, "-crHuanHuoSelect")
			return nil
		end
		return self
	end,
	on_validate_in_response = function(self, user)
		local room = user:getRoom()
		local pattern = self:getUserString()
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		local choices = getResponseChoices(room, user, pattern)
		if #choices == 0 then
			return nil
		end
		choices = table.concat(choices, "+")
		local choice = room:askForChoice(user, "crHuanHuo", choices)
		local card = sgs.Sanguosha:cloneCard(choice, sgs.Card_NoSuit, 0)
		if card:targetFixed() then
			card:setSkillName("crHuanHuo")
			return card
		elseif reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE then
			card:setSkillName("crHuanHuo")
			return card
		end
		room:setPlayerFlag(user, "crHuanHuoSelect")
		room:setPlayerProperty(user, "crHuanHuoType", sgs.QVariant(choice))
		local prompt = string.format("@crHuanHuo:::%s:", choice)
		local success = room:askForUseCard(user, "@@crHuanHuo", prompt)
		if not success then
			room:setPlayerProperty(user, "crHuanHuoType", sgs.QVariant(""))
			room:setPlayerFlag(user, "-crHuanHuoSelect")
			return nil
		end
		return self
	end,
}
HuanHuoVS = sgs.CreateViewAsSkill{
	name = "crHuanHuo",
	n = 0,
	guhuo_type = "lr",
	view_as = function(self, cards)
		if sgs.Self:hasFlag("crHuanHuoSelect") then
			return HuanHuoSelectCard:clone()
		else
			local card = HuanHuoCard:clone()
			local pattern = sgs.Sanguosha:getCurrentCardUsePattern() or ""
			card:setUserString(pattern)
			return card
		end
	end,
	enabled_at_play = function(self, player)
		if player:hasFlag("crHuanHuoSelect") then
			return false
		else
			return true
		end
	end,
	enabled_at_response = function(self, player, pattern)
		if player:hasFlag("crHuanHuoSelect") then
			return pattern == "@@crHuanHuo"
		else
			if string.find(pattern, "@") then
				return false
			elseif string.find(pattern, "#") then
				return false
			end
			return true
		end
	end,
	enabled_at_nullification = function(self, player)
		if player:hasFlag("crHuanHuoSelect") then
			return false
		else
			return true
		end
	end,
}
HuanHuo = sgs.CreateTriggerSkill{
	name = "crHuanHuo",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.CardAsked},
	view_as_skill = HuanHuoVS,
	on_trigger = function(self, event, player, data)
	end,
}
--添加技能
YuJi:addSkill(HuanHuo)
--翻译信息
sgs.LoadTranslationTable{
	["crHuanHuo"] = "幻惑",
	[":crHuanHuo"] = "当你需要使用或打出一张基本牌或非延时性锦囊牌时，你可以视为使用或打出了该牌。 ",
	["$crHuanHuo"] = "万事皆空，幻象新生。",
	["@crHuanHuo"] = "幻惑：请为此【%arg】指定必要的目标",
	["~crHuanHuo"] = "选择一些目标角色->点击“确定”",
	["crhuanhuoselect"] = "幻惑",
	["crhuanhuo"] = "幻惑",
}
--[[
	技能：掀桌（限定技）
	描述：出牌阶段，你可以令所有其他角色弃置所有手牌和装备并失去1点体力上限，然后你立即死亡。
]]--
XianZhuoCard = sgs.CreateSkillCard{
	name = "crXianZhuoCard",
	--skill_name = "crXianZhuo",
	target_fixed = true,
	will_throw = true,
	mute = true,
	on_use = function(self, room, source, targets)
		room:broadcastSkillInvoke("crXianZhuo") --播放配音
		room:notifySkillInvoked(source, "crXianZhuo") --显示技能发动
		room:doLightbox("$crXianZhuoAnimate") --显示全屏信息特效
		local others = room:getOtherPlayers(source)
		for _,p in sgs.qlist(others) do
			p:throwAllHandCardsAndEquips()
			room:loseMaxHp(p, 1)
		end
		room:killPlayer(source)
	end,
}
XianZhuoVS = sgs.CreateViewAsSkill{
	name = "crXianZhuo",
	n = 0,
	view_as = function(self, cards)
		return XianZhuoCard:clone()
	end,
}
XianZhuo = sgs.CreateTriggerSkill{
	name = "crXianZhuo",
	frequency = sgs.Skill_Limited,
	events = {},
	view_as_skill = XianZhuoVS,
	on_trigger = function(self, event, player, data)
	end,
}
--添加技能
YuJi:addSkill(XianZhuo)
--翻译信息
sgs.LoadTranslationTable{
	["crXianZhuo"] = "掀桌",
	[":crXianZhuo"] = "<font color=\"red\"><b>限定技</b></font>，出牌阶段，你可以令所有角色弃置所有手牌和装备并依次失去1点体力上限，然后你立即死亡。",
	["$crXianZhuo"] = "技能 掀桌 的台词",
	["$crXianZhuoAnimate"] = "滚！",
	["crxianzhuo"] = "掀桌",
}