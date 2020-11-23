const fs = require('fs');
const path = require('path');
const scheme = require('ayu').mirage;

const oneColors = {
    scheme: {
        'bg': '#21252B',
        'gd': '#181A1F'
    },
    'focusBorder': '#00000000',
    'list.focusAndSelectionBackground': '#4678CC',
    'list.activeSelectionBackground': '#4678CC',
    'editor.lineHighlightBackground': '#2c313c',
    'editor.rangeHighlightBackground': '#2c313c',
    'sideBarSectionHeader.background': '#2c313c',
    'editor.background': '#282C34',
    'tab.activeBackground': '#282C34',
    'titleBar.activeBackground': '#282C34'
};

const adaptaColors = {
    scheme: {
        'bg': '#222D32',
        'gd': '#181A1F'
    },
    'focusBorder': '#00000000',
    'list.focusAndSelectionBackground': '#4678CC',
    'list.activeSelectionBackground': '#4678CC',
    'editor.lineHighlightBackground': '#303b44',
    'editor.rangeHighlightBackground': '#303b44',
    'sideBarSectionHeader.background': '#303b44',
    'list.hoverBackground': '#303b44',
    'editor.background': '#29353B',
    'tab.activeBackground': '#29353B',
    'titleBar.activeBackground': '#29353B',
    "editorIndentGuide.background": "#dfe9f20a",
    "editorIndentGuide.activeBackground": "#dfe9f20a",
    'selection.background': '#404757fd',
    'editor.selectionBackground': '#404757fd'
};

const mojaveColors = {
    scheme: {
        'fg': '#bababb',
        'rg': '#404041',
        'bg': '#323334',
        'gd': '#181A1F'
    },
    // 'panel.background': '#323334',
    // 'terminal.background': '#323334',
    // 'sideBar.background': '#333335',
    // 'activityBar.background': '#333335',
    // 'statusBar.background': '#333335',
    // 'tab.activeBackground': '#333335',
    // 'titleBar.activeBackground': '#333335',
    'focusBorder': '#00000000',
    'list.focusAndSelectionBackground': '#4678CC',
    'list.activeSelectionBackground': '#4678CC',
    'editor.lineHighlightBackground': '#57575950',
    'editor.rangeHighlightBackground': '#57575950',
    'sideBarSectionHeader.background': '#575759',
    'badge.background': '#959596',
    'activityBarBadge.background': '#959596',
    'list.hoverForeground': '#959596',
    'list.hoverBackground': '#00000000',
    'editor.background': '#292a2f',
    'tab.inactiveBackground': '#262627',
    'editorGroupHeader.tabsBackground': '#262627',
    "editorIndentGuide.background": "#dfe9f20a",
    "editorIndentGuide.activeBackground": "#dfe9f20a",
    'selection.background': '#575759fd',
    'editor.selectionBackground': '#57575990'
}

const exportTheme = (name, mod) => {
    const filepath = path.join(__dirname, '/' + name + '.json');
    const theme = JSON.parse(fs.readFileSync(filepath));

    scheme.common.bg = mod.scheme.bg;
    scheme.ui.panel.rowBg = mod.scheme.rg || scheme.ui.panel.rowBg;
    scheme.ui.fg = mod.scheme.fg || scheme.ui.fg;
    scheme.ui.panel.bg = mod.scheme.bg;
    scheme.ui.gridDivider = mod.scheme.gd;
    delete mod.scheme;

    // https://github.com/ayu-theme/ayu-vim/tree/master/term
    const terminalColors = {
        background: scheme.common.bg,
        foreground: scheme.common.fg,
        black: scheme.ui.gridDivider, // ayu-vim uses #212733
        red: scheme.syntax.supVar,
        green: scheme.syntax.string,
        yellow: scheme.common.accent,
        blue: '#36a3d9',
        magenta: scheme.syntax.constant,
        cyan: scheme.syntax.regexp,
        white: '#c7c7c7',
        brightBlack: '#686868',
        brightRed: scheme.syntax.supVar,
        brightGreen: '#cbe645',
        brightYellow: '#ffdf80',
        brightBlue: '#6871ff',
        brightMagenta: '#ff77ff',
        brightCyan: '#a6fde1',
        brightWhite: '#ffffff'
    };
    
    const themeColors = {
        // ----- Base colors -----
        'foreground': scheme.ui.fg,
        'focusBorder': `${scheme.ui.fg}8A`,
    
        'widget.shadow': `${scheme.ui.panel.shadow}b3`,
    
        'badge.background': scheme.ui.panel.pathFg,
        'badge.foreground': '#fff',
    
        'progressBar.background': scheme.common.accent,
    
        'input.background': scheme.ui.panel.bg,
        'input.foreground': scheme.common.fg,
        'input.border': `${scheme.ui.fg}4C`,
        'input.placeholderForeground': `${scheme.ui.fg}8A`,
    
        'inputOption.activeBorder': `${scheme.ui.fg}8A`,
    
        'inputValidation.infoBackground': scheme.common.bg,
        'inputValidation.infoBorder': scheme.syntax.tag,
        'inputValidation.warningBackground': scheme.common.bg,
        'inputValidation.warningBorder': scheme.syntax.func,
        'inputValidation.errorBackground': scheme.common.bg,
        'inputValidation.errorBorder': scheme.syntax.error,
    
        'dropdown.background': scheme.ui.panel.bg,
        // 'dropdown.foreground': '',
        // 'dropdown.border': '',
    
        'list.focusAndSelectionBackground': scheme.ui.gridDivider,
        'list.focusAndSelectionForeground': scheme.common.fg,
        'list.activeSelectionBackground': scheme.ui.gridDivider,
        'list.activeSelectionForeground': scheme.common.fg,
        'list.inactiveSelectionBackground': scheme.common.bg,
        'list.inactiveSelectionForeground': scheme.common.fg,
        'list.focusBackground': scheme.ui.panel.rowBg,
        'list.focusForeground': scheme.common.fg,
        'list.hoverBackground': scheme.ui.panel.rowBg,
        'list.hoverForeground': scheme.common.fg,
        'list.highlightForeground': scheme.common.accent,
    
        'pickerGroup.foreground': scheme.common.accent,
        'pickerGroup.border': scheme.ui.gridDivider,
    
        'button.background': `${scheme.common.accent}AA`,
        'button.hoverBackground': `${scheme.common.accent}BB`,
        'button.foreground': '#fff',
    
        'scrollbar.shadow': `${scheme.ui.panel.shadow}11`,
        'scrollbarSlider.background': `${scheme.ui.scrollbar.puck}11`,
        'scrollbarSlider.hoverBackground': `${scheme.ui.scrollbar.puck}22`,
        'scrollbarSlider.activeBackground': `${scheme.ui.scrollbar.puck}22`,
    
        // See http://stackoverflow.com/a/7224621 for the semi-transparent issue workaround
        'selection.background': `${scheme.syntax.selection}fd`,
    
        // ----- Editor -----
        'editor.background': scheme.common.bg,
        'editor.foreground': scheme.common.fg,
        'editor.selectionBackground': scheme.syntax.selection,
        // 'editor.inactiveSelectionBackground': '',
        // 'editor.selectionHighlightBackground': '',
        'editor.findMatchBackground': `${scheme.common.accent}33`,
        'editor.findMatchHighlightBackground': `${scheme.common.accent}33`,
        'editor.findRangeHighlightBackground': `${scheme.common.accent}33`,
        'editorLink.activeForeground': scheme.common.accent,
        'editorLink.foreground': scheme.common.accent,
        'editorWidget.background': scheme.ui.panel.bg,
        'editor.lineHighlightBackground': scheme.syntax.lineHg,
        // 'editor.lineHighlightBorder': '',
        'editor.rangeHighlightBackground': scheme.syntax.lineHg,
        'editor.wordHighlightBackground': `${scheme.common.accent}33`,
        'editor.wordHighlightStrongBackground': `${scheme.common.accent}33`,
        'editorCursor.foreground': scheme.common.accent,
        'editorWhitespace.foreground': scheme.syntax.gutter,
        'editorIndentGuide.background': scheme.syntax.gutter,
        'editorLineNumber.foreground': scheme.syntax.gutter,
        'editorMarkerNavigation.background': scheme.ui.panel.bg,
        // 'editor.hoverHighlightBackground': '',
        'editorHoverWidget.background': scheme.ui.panel.bg,
        'editorHoverWidget.border': scheme.ui.gridDivider,
        // 'editorBracketMatch.background': '',
        'editorBracketMatch.border': scheme.common.accent + '90',
        'editorOverviewRuler.border': scheme.ui.gridDivider,
        'editorOverviewRuler.errorForeground': scheme.syntax.error,
        'editorOverviewRuler.warningForeground': scheme.common.accent,
        'editorRuler.foreground': scheme.ui.gridDivider,
    
        // ----- Editor error squiggles -----
        'editorError.foreground': scheme.syntax.error,
        'editorWarning.foreground': scheme.common.accent,
    
        // ----- Editor gutter -----
        'editorGutter.modifiedBackground': scheme.syntax.tag,
        'editorGutter.addedBackground': scheme.syntax.string,
        'editorGutter.deletedBackground': scheme.syntax.error,
    
        // ----- Editor suggest -----
        'editorSuggestWidget.background': scheme.ui.panel.bg,
        'editorSuggestWidget.border': scheme.ui.gridDivider,
        'editorSuggestWidget.selectedBackground': scheme.ui.panel.rowBg,
        'editorSuggestWidget.highlightForeground': scheme.common.accent,
    
        // ----- Peek view editor -----
        'peekView.border': scheme.ui.gridDivider,
        'peekViewEditor.background': scheme.ui.panel.bg,
        'peekViewEditor.matchHighlightBackground': `${scheme.common.accent}33`,
        'peekViewTitle.background': scheme.ui.panel.bg,
        'peekViewTitleLabel.foreground': scheme.ui.fg,
        'peekViewTitleDescription.foreground': scheme.ui.fg,
        'peekViewResult.background': scheme.ui.panel.bg,
        'peekViewResult.matchHighlightBackground': `${scheme.common.accent}33`,
        'peekViewResult.fileForeground': scheme.ui.fg,
    
        //  ----- Diff editor -----
        'diffEditor.insertedTextBackground': `${scheme.syntax.regexp}44`,
        'diffEditor.removedTextBackground': `${scheme.syntax.supVar}44`,
    
        // ----- Workbench: editor group -----
        'editorGroup.background': scheme.ui.panel.bg,
        'editorGroup.border': scheme.ui.gridDivider,
        'editorGroupHeader.tabsBackground': scheme.common.bg,
        'editorGroupHeader.noTabsBackground': scheme.common.bg,
        "editorGroupHeader.tabsBorder": scheme.ui.gridDivider,
    
        // ----- Workbench: tabs -----
        'tab.activeBackground': scheme.ui.panel.bg,
        'tab.inactiveBackground': scheme.common.bg,
        'tab.activeForeground': scheme.common.fg,
        'tab.activeBorder': scheme.common.accent,
        'tab.inactiveForeground': scheme.ui.fg,
        'tab.border': scheme.ui.gridDivider,
        'tab.unfocusedActiveForeground': `${scheme.common.fg}AA`,
        'tab.unfocusedInactiveForeground': scheme.ui.fg,
        'tab.unfocusedActiveBorder': scheme.common.accent,
    
        // ----- Workbench: panel -----
        'panel.background': scheme.common.bg,
        'panel.border': scheme.ui.gridDivider,
        'panelTitle.activeForeground': scheme.common.fg,
        'panelTitle.inactiveForeground': scheme.ui.fg,
        'panelTitle.activeBorder': scheme.common.accent,
    
        // ----- Workbench: status bar -----
        'statusBar.foreground': scheme.ui.fg,
        'statusBar.background': scheme.ui.panel.bg,
        'statusBar.border': scheme.ui.gridDivider,
        'statusBar.noFolderBackground': scheme.ui.panel.bg,
        'statusBar.debuggingBackground': scheme.ui.panel.bg,
        'statusBar.debuggingForeground': scheme.ui.fg,
        'statusBarItem.activeBackground': scheme.ui.gridDivider,
        // 'statusBarItem.hoverBackground': scheme.ui.panel.rowBg,
        'statusBarItem.prominentBackground': scheme.ui.gridDivider,
        'statusBarItem.prominentHoverBackground': scheme.ui.panel.rowBg,
        'statusBarItem.remoteBackground': scheme.common.accent,
        'statusBarItem.remoteForeground': scheme.common.bg,
    
        // ----- Workbench: activity bar -----
        'activityBar.background': scheme.common.bg,
        'activityBar.foreground': scheme.ui.fg,
        'activityBar.border': scheme.ui.gridDivider,
        'activityBarBadge.background': scheme.syntax.activeGuide,
        'activityBarBadge.foreground': '#fff',
    
        // ----- Workbench: side bar -----
        'sideBar.background': scheme.common.bg,
        'sideBarTitle.foreground': scheme.ui.fg,
        'sideBarSectionHeader.background': scheme.syntax.lineHg,
        'sideBarSectionHeader.foreground': scheme.ui.fg,
        'sideBar.border': scheme.ui.gridDivider,
    
        // ----- Workbench: title bar -----
        'titleBar.activeForeground': scheme.ui.fg,
        'titleBar.inactiveForeground': scheme.ui.fg,
        'titleBar.activeBackground': scheme.common.bg,
        'titleBar.inactiveBackground': scheme.common.bg,
        'titleBar.border': scheme.ui.gridDivider,
    
        // ----- Workbench: notifications -----
        'notification.background': scheme.ui.gridDivider,
    
        // ----- Workbench: extension buttons -----
        'extensionButton.prominentBackground': `${scheme.common.accent}AA`,
        'extensionButton.prominentHoverBackground': `${scheme.common.accent}BB`,
        'extensionButton.prominentForeground': '#fff',
    
        // ----- Workbench: welcome page / interactive playground -----
        'welcomePage.quickLinkBackground': scheme.ui.panel.rowBg,
        'welcomePage.quickLinkHoverBackground': scheme.ui.gridDivider,
        'welcomeOverlay.foreground': scheme.common.fg,
        'walkThrough.embeddedEditorBackground': scheme.ui.panel.bg,
        'textLink.foreground': scheme.common.accent,
        'textLink.activeForeground': scheme.common.accent,
        'textPreformat.foreground': scheme.common.fg,
        'textBlockQuote.background': scheme.ui.panel.bg,
    
        // ----- Workbench: debug -----
        'debugExceptionWidget.border': scheme.ui.gridDivider,
        'debugExceptionWidget.background': scheme.ui.panel.bg,
        'debugToolBar.background': scheme.ui.panel.bg,
    
        // ----- Workbench: terminal -----
        'terminal.background': terminalColors.background,
        'terminal.foreground': terminalColors.foreground,
        'terminal.ansiBlack': terminalColors.black,
        'terminal.ansiRed': terminalColors.red,
        'terminal.ansiGreen': terminalColors.green,
        'terminal.ansiYellow': terminalColors.yellow,
        'terminal.ansiBlue': terminalColors.blue,
        'terminal.ansiMagenta': terminalColors.magenta,
        'terminal.ansiCyan': terminalColors.cyan,
        'terminal.ansiWhite': terminalColors.white,
        'terminal.ansiBrightBlack': terminalColors.brightBlack,
        'terminal.ansiBrightRed': terminalColors.brightRed,
        'terminal.ansiBrightGreen': terminalColors.brightGreen,
        'terminal.ansiBrightYellow': terminalColors.brightYellow,
        'terminal.ansiBrightBlue': terminalColors.brightBlue,
        'terminal.ansiBrightMagenta': terminalColors.brightMagenta,
        'terminal.ansiBrightCyan': terminalColors.brightCyan,
        'terminal.ansiBrightWhite': terminalColors.brightWhite
    };

    theme.colors = themeColors;
    Object.assign(theme.colors, mod);

    fs.writeFileSync(filepath, JSON.stringify(theme, null, '\t'));
    console.log(`Updated ${filepath}`);
};

exportTheme('ayu-one', oneColors);
exportTheme('ayu-adapta', adaptaColors);
exportTheme('ayu-mojave', mojaveColors);