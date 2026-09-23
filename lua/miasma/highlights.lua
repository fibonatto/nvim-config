local U = require("miasma.util")

local M = {}

function M.apply(p)
	local bg_alt = p.bg_alt or p.ui
	local bg_soft = p.bg_soft or p.cursorline
	local border = p.border or p.ui
	local fg_soft = p.fg_soft or p.comment
	local err = p.error or p.variable

	-- ==========================================
	-- 1. CORES DO TERMINAL (Neovim Terminal)
	-- ==========================================
	vim.g.terminal_color_0 = p.bg
	vim.g.terminal_color_1 = err
	vim.g.terminal_color_2 = p.string
	vim.g.terminal_color_3 = p.number
	vim.g.terminal_color_4 = p.func
	vim.g.terminal_color_5 = p.keyword
	vim.g.terminal_color_6 = p.variable
	vim.g.terminal_color_7 = p.fg
	vim.g.terminal_color_8 = p.comment
	vim.g.terminal_color_9 = err
	vim.g.terminal_color_10 = p.string
	vim.g.terminal_color_11 = p.number
	vim.g.terminal_color_12 = p.func
	vim.g.terminal_color_13 = p.keyword
	vim.g.terminal_color_14 = p.variable
	vim.g.terminal_color_15 = p.fg

	-- ==========================================
	-- 2. GRUPOS BASE DO EDITOR
	-- ==========================================
	U.h("Normal", { fg = p.fg, bg = p.bg })
	U.h("NormalNC", { fg = p.fg, bg = p.bg })
	U.h("Cursor", { fg = p.bg, bg = p.fg })
	U.h("CursorLine", { bg = p.cursorline })
	U.h("ColorColumn", { bg = bg_soft })
	U.h("LineNr", { fg = p.gutter })
	U.h("Visual", { bg = p.visual })
	U.h("Search", { fg = p.fg, bg = p.search })
	U.h("IncSearch", { fg = p.bg, bg = p.number, bold = true })
	U.h("MatchParen", { fg = p.bg, bg = p.func, bold = true })
	U.h("Underlined", { fg = p.func, underline = true })

	-- Mensagens e UI Base
	U.h("ErrorMsg", { fg = err, bg = p.bg })
	U.h("WarningMsg", { fg = p.number, bg = p.bg })
	U.h("Todo", { fg = p.keyword, bg = p.bg, bold = true, italic = true })
	U.h("VertSplit", { fg = border, bg = p.bg })
	U.h("StatusLine", { fg = p.fg, bg = bg_alt })
	U.h("StatusLineNC", { fg = p.comment, bg = bg_alt })
	U.h("NormalFloat", { fg = p.fg, bg = bg_alt })
	U.h("FloatBorder", { fg = border, bg = bg_alt })
	U.h("FloatTitle", { fg = p.func, bg = bg_alt })
	U.h("Pmenu", { fg = p.fg, bg = bg_alt })
	U.h("PmenuSel", { fg = p.bg, bg = p.func })

	-- Correção Ortográfica (Spell Check com underline colorida)
	U.h("SpellBad", { sp = err, undercurl = true })
	U.h("SpellCap", { sp = p.func, undercurl = true })
	U.h("SpellLocal", { sp = p.number, undercurl = true })
	U.h("SpellRare", { sp = p.keyword, undercurl = true })

	-- ==========================================
	-- 3. SINTAXE BASE E TREESITTER (Núcleo)
	-- ==========================================
	U.h("Comment", { fg = p.comment, italic = true })
	U.h("Constant", { fg = p.number })
	U.h("String", { fg = p.string })
	U.h("Identifier", { fg = p.variable })
	U.h("Function", { fg = p.func, bold = true })
	U.h("Statement", { fg = p.keyword })
	U.h("Keyword", { fg = p.keyword, bold = true })
	U.h("PreProc", { fg = p.func })
	U.h("Type", { fg = p.number })
	U.h("Special", { fg = p.variable })
	U.h("Operator", { fg = p.fg })
	U.h("Error", { fg = err, bold = true })

	-- ==========================================
	-- 4. DIAGNOSTICS & DIFFS (Criados via Loop)
	-- ==========================================
	local diagnostics = { Error = err, Warn = p.number, Info = p.func, Hint = p.comment }
	for sev, color in pairs(diagnostics) do
		U.h("Diagnostic" .. sev, { fg = color })
		U.h("DiagnosticSign" .. sev, { fg = color, bg = p.bg })
		U.h("DiagnosticVirtualText" .. sev, { fg = color, bg = bg_soft })
		U.h("DiagnosticFloating" .. sev, { fg = color, bg = bg_alt })
		U.h("DiagnosticUnderline" .. sev, { sp = color, undercurl = true })
	end

	U.h("DiffAdd", { fg = p.string, bg = p.diff_add })
	U.h("DiffChange", { fg = p.number, bg = p.diff_change })
	U.h("DiffDelete", { fg = err, bg = p.diff_delete })
	U.h("DiffText", { fg = p.fg, bg = p.diff_change, bold = true })

	-- ==========================================
	-- 5. DICIONÁRIO GIGANTE DE LINKS
	-- ==========================================
	local links = {
		-- UI Secundária e Legados
		CursorColumn = "CursorLine",
		CursorLineNr = "Function",
		SignColumn = "LineNr",
		FoldColumn = "LineNr",
		WinSeparator = "VertSplit",
		CurSearch = "IncSearch",
		VisualNOS = "Visual",
		MoreMsg = "String",
		Question = "Function",
		PmenuSbar = "ColorColumn",
		PmenuThumb = "Comment",
		TabLine = "StatusLineNC",
		TabLineFill = "StatusLineNC",
		TabLineSel = "StatusLine",
		WildMenu = "PmenuSel",

		-- Sintaxe Complementar
		Character = "String",
		Number = "Constant",
		Boolean = "Constant",
		Float = "Constant",
		Conditional = "Statement",
		Repeat = "Statement",
		Label = "Statement",
		Exception = "Statement",
		Include = "Keyword",
		Define = "Keyword",
		Macro = "Function",
		PreCondit = "Keyword",
		StorageClass = "Keyword",
		Structure = "Keyword",
		Typedef = "Keyword",
		SpecialChar = "Special",
		Tag = "Special",
		Delimiter = "Operator",
		SpecialComment = "Comment",
		Debug = "Special",

		-- Diff Legado
		diffAdded = "DiffAdd",
		diffRemoved = "DiffDelete",
		diffChanged = "DiffChange",
		diffFile = "Comment",
		diffLine = "Function",

		-- Treesitter Atual (@...)
		["@comment"] = "Comment",
		["@keyword"] = "Keyword",
		["@string"] = "String",
		["@function"] = "Function",
		["@function.builtin"] = "Function",
		["@variable"] = "Identifier",
		["@variable.builtin"] = "Special",
		["@variable.parameter"] = "Identifier",
		["@property"] = "Identifier",
		["@number"] = "Number",
		["@boolean"] = "Boolean",
		["@operator"] = "Operator",
		["@type"] = "Type",
		["@punctuation.delimiter"] = "Delimiter",
		["@punctuation.bracket"] = "Delimiter",

		-- Treesitter Legado (TS...) do seu arquivo vim
		TSComment = "Comment",
		TSFunction = "Function",
		TSKeyword = "Keyword",
		TSString = "String",
		TSNumber = "Number",
		TSVariable = "Identifier",
		TSProperty = "Identifier",
		TSType = "Type",
		TSOperator = "Operator",

		-- Plugins (Telescope, NERDTree, Coc, ALE, GitGutter)
		TelescopeBorder = "FloatBorder",
		TelescopePromptBorder = "Function",
		TelescopeResultsBorder = "FloatBorder",
		TelescopePreviewBorder = "FloatBorder",
		TelescopeMatching = "Function",
		TelescopePromptPrefix = "Special",

		NERDTreeFile = "Normal",
		NERDTreeExecFile = "String",
		NERDTreeDir = "Function",
		NERDTreeDirSlash = "Function",
		NERDTreeCWD = "Keyword",
		NERDTreeOpenable = "String",
		NERDTreeClosable = "Identifier",
		NERDTreeUp = "Comment",

		GitGutterAdd = "DiffAdd",
		GitGutterChange = "DiffChange",
		GitGutterDelete = "DiffDelete",
		GitGutterChangeDelete = "DiffChange",

		ALEError = "DiagnosticError",
		ALEWarning = "DiagnosticWarn",
		ALEErrorSign = "DiagnosticSignError",
		ALEWarningSign = "DiagnosticSignWarn",

		CocErrorSign = "DiagnosticSignError",
		CocWarningSign = "DiagnosticSignWarn",
		CocInfoSign = "DiagnosticSignInfo",
		CocHintSign = "DiagnosticSignHint",

		LspErrorText = "DiagnosticError",
		LspWarningText = "DiagnosticWarn",
		LspInformationText = "DiagnosticInfo",
		LspHintText = "DiagnosticHint",
		LspReferenceHighlight = "CursorLine",
		LspHover = "NormalFloat",

		-- Linguagens Específicas (Legadas por Regex)
		htmlTag = "Identifier",
		htmlEndTag = "Identifier",
		htmlTagName = "Identifier",
		cssProp = "Normal",
		cssIdentifier = "Function",
		cssClassName = "Constant",
		javaScriptFunction = "Keyword",
		javaScriptMember = "Identifier",
		pythonOperator = "Keyword",
		rubySymbol = "String",
		phpMemberSelector = "Normal",
		markdownCode = "String",
		markdownH1 = "Identifier",
		markdownH2 = "Identifier",
		markdownLinkText = "Function",
		markdownUrl = "Constant",
	}

	-- Aplica a montanha de links (resolve mais de 150 linhas em um laço)
	for k, v in pairs(links) do
		U.h(k, { link = v })
	end

	-- Casos pontuais remanescentes
	U.h("@markup.heading", { fg = p.variable, bold = true })
	U.h("@markup.italic", { italic = true })
	U.h("@markup.strong", { bold = true })
	U.h("MiniIndentscopeSymbol", { fg = border })
end

return M
