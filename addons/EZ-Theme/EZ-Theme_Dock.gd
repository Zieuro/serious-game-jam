@tool
extends Control

###########
# VARIABLES
###########
const EZ_SAVE_PATH = "res://EZ_Theme.tres"

@onready var theme_LineEdit: LineEdit = %Theme_LineEdit
@onready var theme_Button: Button = %Theme_Button
@onready var themeNew_Button: Button = %ThemeNew_Button

@onready var font_LineEdit: LineEdit = %Font_LineEdit
@onready var font_Button: Button = %Font_Button
@onready var fontSize_SpinBox: SpinBox = %FontSize_SpinBox
@onready var fontColor_ColorPicker: ColorPickerButton = %FontColor_ColorPickerButton
const FONT_BASE = ["font"]
const FONT_COLOR_BASE = ["font_color", "font_selected_color"]
const FONT_SIZE_BASE = ["font_size", "bold_font_size", "bold_italics_font_size", "italics_font_size", "mono_font_size", "normal_font_size", "title_button_font_size", "title_font_size"]

@onready var colorPrimary_ColorPicker: ColorPickerButton = %ColorPrimary_ColorPickerButton
@onready var colorSecondary_ColorPicker: ColorPickerButton = %ColorSecondary_ColorPickerButton
@onready var colorTertiary_ColorPicker: ColorPickerButton = %ColorTertiary_ColorPickerButton
const STYLE_COLOR_PRIMARY_TRUMP_BASE : String = "normal"
const STYLE_COLOR_PRIMARY_TAB_BASE : String = "tab_selected"
const STYLE_COLOR_SECONDARY_TAB_BASE : String = "tab"
const STYLE_PROPERTY_PANEL : String = "panel"
const STYLE_COLOR_PRIMARY_BASE = ["normal", "fill", "slider", "grabber", "tab_selected", "separator", "selected"]
const STYLE_COLOR_SECONDARY_BASE = ["scroll", "panel", "grabber_area", "split_bar_background", "background"]
const STYLE_COLOR_TERTIARY_BASE = []	# properties can be added here to apply a tertiary color

@onready var save_Button: Button = %Save_Button
@onready var revert_Button: Button = %Revert_Button

var font_FileDialog: FileDialog
var theme_FileDialog: FileDialog

var tempTheme : Theme
var allControlClasses : PackedStringArray
var fontControlClasses : PackedStringArray
var styleboxControlClasses : PackedStringArray

###########
# FUNCTIONS
###########
#######################################################
# FUNC:		_ready
# DESC:		Ready Initialization
# PARAM:	None
# RETURN:	None
#######################################################
func _ready() -> void:	
	# Theme
	theme_FileDialog = FileDialog.new()
	theme_FileDialog.access = FileDialog.ACCESS_RESOURCES
	theme_FileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	theme_FileDialog.title = "Select Theme File"
	theme_FileDialog.size = Vector2i(650, 450)
	theme_FileDialog.filters = ["*.tres ; Theme Files"]
	theme_FileDialog.file_selected.connect(_on_Theme_selected)
	add_child(theme_FileDialog)
	
	theme_Button.pressed.connect(_on_ThemeButton_pressed)
	themeNew_Button.pressed.connect(_on_ThemeNewButton_pressed)
	
	# Font
	font_FileDialog = FileDialog.new()
	font_FileDialog.access = FileDialog.ACCESS_RESOURCES
	font_FileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	font_FileDialog.title = "Select Font File"
	font_FileDialog.size = Vector2i(650, 450)
	font_FileDialog.filters = ["*.ttf, *.otf, *.woff, *.woff2 ; Font Files"]
	font_FileDialog.file_selected.connect(_on_Font_selected)
	add_child(font_FileDialog)
	
	font_Button.pressed.connect(_on_FontButton_pressed)
	fontSize_SpinBox.value_changed.connect(_on_FontSize_changed)
	fontColor_ColorPicker.color = Color.BLACK
	fontColor_ColorPicker.color_changed.connect(_on_FontColor_changed)
	
	# Colors
	colorPrimary_ColorPicker.color = Color.DARK_SLATE_GRAY
	colorPrimary_ColorPicker.color_changed.connect(_on_PrimaryColor_changed)
	colorSecondary_ColorPicker.color = Color.CADET_BLUE
	colorSecondary_ColorPicker.color_changed.connect(_on_SecondaryColor_changed)
	colorTertiary_ColorPicker.color = Color.LIGHT_GOLDENROD
	colorTertiary_ColorPicker.color_changed.connect(_on_TertiaryColor_changed)
	
	# Save
	save_Button.pressed.connect(_on_SaveButton_pressed)
	# Revert
	revert_Button.pressed.connect(_on_RevertButton_pressed)
	
	EnableButtons(false)
	
#######################################################
# FUNC:		ShowTempChanges
# DESC:		Opens the theme editor window
# PARAM:	None
# RETURN:	None
#######################################################
func ShowTempChanges() -> void:
	# Fetch the main EditorInterface context
	EditorInterface.edit_resource(tempTheme)

#######################################################
# FUNC:		EnableButtons
# DESC:		Controls if the settings buttons are enabled
# PARAM:	enable (bool) - true = enabled, false = disabled
# RETURN:	None
#######################################################
func EnableButtons(enable : bool) -> void:
	font_Button.disabled = not enable
	fontSize_SpinBox.editable = enable
	fontColor_ColorPicker.disabled = not enable
	
	colorPrimary_ColorPicker.disabled = not enable
	colorSecondary_ColorPicker.disabled = not enable
	colorTertiary_ColorPicker.disabled = not enable

#######################################################
# FUNC:		ButtonDefaults
# DESC:		Sets the control buttons to be the values already
#           in the selected theme. uses the label, button, and panel data
# PARAM:	None
# RETURN:	None
#######################################################
func ButtonDefaults() -> void:
	fontSize_SpinBox.value = tempTheme.get_theme_item(Theme.DATA_TYPE_FONT_SIZE, "font_size", "Label")
	fontColor_ColorPicker.color = tempTheme.get_theme_item(Theme.DATA_TYPE_COLOR, "font_color", "Label")
	
	colorPrimary_ColorPicker.color = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, "normal", "Button").bg_color
	colorSecondary_ColorPicker.color = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, "panel", "Panel").bg_color
	
#######################################################
# FUNC:		GetControls
# DESC:		Gets all the control nodes, font nodes, and stylebox node
#			to speed things up later
# PARAM:	None
# RETURN:	None
#######################################################
func GetControls() -> void:
	# all controls
	allControlClasses = ClassDB.get_inheriters_from_class("Control")
	fontControlClasses = tempTheme.get_font_type_list()
	styleboxControlClasses = tempTheme.get_stylebox_type_list()
			
#################
# THEME FUNCTIONS
#################
#######################################################
# FUNC:		_on_ThemeButton_pressed
# DESC:		Opens the theme select dialog
# PARAM:	None
# RETURN:	None
#######################################################
func _on_ThemeButton_pressed() -> void:
	theme_FileDialog.popup_file_dialog()

#######################################################
# FUNC:		_on_ThemeNewButton_pressed
# DESC:		Save the default theme to the EZ_SAVE_PATH
# PARAM:	None
# RETURN:	None
#######################################################
func _on_ThemeNewButton_pressed() -> void:
	# Save the default theme to your project files
	var error = ResourceSaver.save(ThemeDB.get_default_theme(), EZ_SAVE_PATH)
	_on_Theme_selected(EZ_SAVE_PATH)
	
#######################################################
# FUNC:		_on_Theme_selected
# DESC:		Sets the theme to modify, default button values, and enables buttons
# PARAM:	path (String) - path to the file
# RETURN:	None
#######################################################
func _on_Theme_selected(path: String) -> void:
	theme_LineEdit.text = path
	# duplicate the theme resource into memory
	tempTheme = ResourceLoader.load(theme_LineEdit.text, "", ResourceLoader.CACHE_MODE_IGNORE).duplicate(true)
	ShowTempChanges()
	GetControls()
	EnableButtons(true)
	ButtonDefaults()
	
################
# FONT FUNCTIONS
################
#######################################################
# FUNC:		_on_FontButton_pressed
# DESC:		Opens the font select dialog
# PARAM:	None
# RETURN:	None
#######################################################
func _on_FontButton_pressed() -> void:
	font_FileDialog.popup_file_dialog()
	
#######################################################
# FUNC:		_on_Font_selected
# DESC:		Applies selected font to the theme font nodes
# PARAM:	path (String) - path to the file
# RETURN:	None
#######################################################
func _on_Font_selected(path: String) -> void:
	font_LineEdit.text = path
	
	# set default font
	var fontFile = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	tempTheme.default_font = fontFile
	
	# set item property font
	for type in fontControlClasses:
		for property in FONT_BASE:
			if tempTheme.has_font(property, type):
				tempTheme.set_font(property, type, fontFile)
	
	ShowTempChanges()
	
#######################################################
# FUNC:		_on_FontSize_changed
# DESC:		Applies font size to the theme font nodes
# PARAM:	newValue (float) - new font size
# RETURN:	None
#######################################################
func _on_FontSize_changed(newValue : float) -> void:
	# set default font
	tempTheme.default_font_size = newValue
	
	# set item property font
	for type in fontControlClasses:
		for property in FONT_SIZE_BASE:
			if tempTheme.has_font_size(property, type):
				tempTheme.set_font_size(property, type, newValue)
				
	ShowTempChanges()

#######################################################
# FUNC:		_on_FontColor_changed
# DESC:		Applies font color to the theme font nodes.
#			Uses the already present colors to apply color offset for 
#			things like hover, disabled, in focus, ect.
# PARAM:	newColor (Color) - new font color
# RETURN:	None
#######################################################
func _on_FontColor_changed(newColor : Color) -> void:
	for type in fontControlClasses:
		# get the base color to ratio later
		var baseColor : Color = Color.BLACK
		for property in FONT_COLOR_BASE:
			if tempTheme.has_theme_item(Theme.DATA_TYPE_COLOR, property, type):
				baseColor = tempTheme.get_theme_item(Theme.DATA_TYPE_COLOR, property, type)
				break
		
		# update colors
		for property in tempTheme.get_color_list(type):
			# check if a base property
			if FONT_COLOR_BASE.has(property):
				tempTheme.set_theme_item(Theme.DATA_TYPE_COLOR, property, type, newColor)
			else:
				# set as ratio of the original theme
				var tempColor : Color = tempTheme.get_theme_item(Theme.DATA_TYPE_COLOR, property, type)
				var tempColorRatio : Color = tempColor - baseColor
				tempTheme.set_theme_item(Theme.DATA_TYPE_COLOR, property, type, newColor + tempColorRatio)
				
	ShowTempChanges()

##################
# COLORS FUNCTIONS
##################
#######################################################
# FUNC:		_on_PrimaryColor_changed
# DESC:		Applies the colors to the theme stylebox nodes.
#			Uses the already present colors to apply color offset for 
#			things like hover, disabled, in focus, ect.
#			This function is called by all color pickers
# PARAM:	_newColor (Color) - new color
# RETURN:	None
#######################################################
func _on_PrimaryColor_changed(_newColor : Color) -> void:
	for type in styleboxControlClasses:
		var tempPropertyList = tempTheme.get_stylebox_list(type)
		
		# get the base colors to ratio later
		var basePrimaryStyle : StyleBox = StyleBox.new()
		var basePrimaryColor : Color = Color.BLACK
		var basePrimaryColorFloat : float = basePrimaryColor.get_luminance()
		var basePrimaryString : String = ""
		var baseSecondaryStyle : StyleBox = StyleBox.new()
		var baseSecondaryColor : Color = Color.BLACK
		var baseSecondaryColorFloat : float = baseSecondaryColor.get_luminance()
		var baseSecondaryString : String = ""
		
		for property in tempPropertyList:
			if STYLE_COLOR_PRIMARY_BASE.has(property):
				basePrimaryStyle = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, property, type)
				basePrimaryString = property
				if "bg_color" in basePrimaryStyle:
					basePrimaryColor = basePrimaryStyle.bg_color
					basePrimaryColorFloat = basePrimaryColor.get_luminance()
				else:
					basePrimaryColor = Color.TRANSPARENT
					
				basePrimaryColorFloat = basePrimaryColor.get_luminance()
				
			elif STYLE_COLOR_SECONDARY_BASE.has(property):
				baseSecondaryStyle = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, property, type)
				baseSecondaryString = property
				if "bg_color" in baseSecondaryStyle:
					baseSecondaryColor = baseSecondaryStyle.bg_color
				else:
					baseSecondaryColor = Color.TRANSPARENT
					
				baseSecondaryColorFloat = baseSecondaryColor.get_luminance()
			else:
				pass
		
		# update stylebox colors
		for property in tempPropertyList:
			if property == basePrimaryString:
				if "bg_color" in basePrimaryStyle:
					basePrimaryStyle.bg_color = colorPrimary_ColorPicker.color
			# needs to be before secondary check
			elif basePrimaryString == STYLE_COLOR_PRIMARY_TAB_BASE and \
			property == STYLE_PROPERTY_PANEL:
				var tempStyle = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, property, type)
				if "bg_color" in tempStyle:
					tempStyle.bg_color = colorPrimary_ColorPicker.color
			elif property == baseSecondaryString:
				if "bg_color" in baseSecondaryStyle:
					baseSecondaryStyle.bg_color = colorSecondary_ColorPicker.color
			elif STYLE_COLOR_PRIMARY_BASE.any(func(text): return text.contains(property)) or \
			basePrimaryString == STYLE_COLOR_PRIMARY_TRUMP_BASE:
				# set as ratio of the original theme
				var tempStyle = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, property, type)
				if "bg_color" in tempStyle:
					var tempColor : Color = tempStyle.bg_color
					var tempColorRatio : Color = tempColor - colorPrimary_ColorPicker.color
					tempStyle.bg_color = colorPrimary_ColorPicker.color * basePrimaryColorFloat
			elif STYLE_COLOR_SECONDARY_BASE.any(func(text): return text.contains(property)) or \
			property.contains(STYLE_COLOR_SECONDARY_TAB_BASE):
				# set as ratio of the original theme
				var tempStyle = tempTheme.get_theme_item(Theme.DATA_TYPE_STYLEBOX, property, type)
				if "bg_color" in tempStyle:
					var tempColor : Color = tempStyle.bg_color
					var tempColorRatio : Color = tempColor - colorSecondary_ColorPicker.color
					tempStyle.bg_color = colorSecondary_ColorPicker.color * baseSecondaryColorFloat
			elif STYLE_COLOR_TERTIARY_BASE.any(func(text): return text.contains(property)):
				pass
			else:
				pass
				
	ShowTempChanges()

#######################################################
# FUNC:		_on_SecondaryColor_changed
# DESC:		Calls _on_PrimaryColor_changed to do the work.
#			Could I just point all pickers to the same function, yes...
#			But maybe there is something you want to do here.
# PARAM:	newColor (Color) - new color
# RETURN:	None
#######################################################
func _on_SecondaryColor_changed(newColor : Color) -> void:
	_on_PrimaryColor_changed(newColor)
	
#######################################################
# FUNC:		_on_TertiaryColor_changed
# DESC:		Calls _on_PrimaryColor_changed to do the work.
#			Could I just point all pickers to the same function, yes...
#			But maybe there is something you want to do here.
# PARAM:	newColor (Color) - new color
# RETURN:	None
#######################################################
func _on_TertiaryColor_changed(newColor : Color) -> void:
	_on_PrimaryColor_changed(newColor)
	
#######################
# SAVE/REVERT FUNCTIONS
#######################
#######################################################
# FUNC:		_on_SaveButton_pressed
# DESC:		Saves the new theme to the select theme path
# PARAM:	None
# RETURN:	None
#######################################################
func _on_SaveButton_pressed() -> void:
	var error = ResourceSaver.save(tempTheme, theme_LineEdit.text)
	_on_Theme_selected(theme_LineEdit.text)

#######################################################
# FUNC:		_on_RevertButton_pressed
# DESC:		Discards changes and reloads the selected theme
# PARAM:	None
# RETURN:	None
#######################################################
func _on_RevertButton_pressed() -> void:
	_on_Theme_selected(theme_LineEdit.text)
