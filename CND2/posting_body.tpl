<script type="text/javascript">
<!--
// bbCode control by
// subBlue design
// www.subBlue.com

// Startup variables
var imageTag = false;
var theSelection = false;

// Check for Browser & Platform for PC & IE specific bits
// More details from: http://www.mozilla.org/docs/web-developer/sniffer/browser_type.html
var clientPC = navigator.userAgent.toLowerCase(); // Get client info
var clientVer = parseInt(navigator.appVersion); // Get browser version

var is_ie = ((clientPC.indexOf("msie") != -1) && (clientPC.indexOf("opera") == -1));
var is_nav = ((clientPC.indexOf('mozilla')!=-1) && (clientPC.indexOf('spoofer')==-1)
                && (clientPC.indexOf('compatible') == -1) && (clientPC.indexOf('opera')==-1)
                && (clientPC.indexOf('webtv')==-1) && (clientPC.indexOf('hotjava')==-1));
var is_moz = 0;

var is_win = ((clientPC.indexOf("win")!=-1) || (clientPC.indexOf("16bit") != -1));
var is_mac = (clientPC.indexOf("mac")!=-1);

// Helpline messages
b_help = "{L_BBCODE_B_HELP}";
i_help = "{L_BBCODE_I_HELP}";
u_help = "{L_BBCODE_U_HELP}";
q_help = "{L_BBCODE_Q_HELP}";
c_help = "{L_BBCODE_C_HELP}";
l_help = "{L_BBCODE_L_HELP}";
o_help = "{L_BBCODE_O_HELP}";
p_help = "{L_BBCODE_P_HELP}";
w_help = "{L_BBCODE_W_HELP}";
a_help = "{L_BBCODE_A_HELP}";
s_help = "{L_BBCODE_S_HELP}";
f_help = "{L_BBCODE_F_HELP}";

// Define the bbCode tags
bbcode = new Array();
bbtags = new Array('[b]','[/b]','[i]','[/i]','[u]','[/u]','[quote]','[/quote]','[code]','[/code]','[list]','[/list]','[list=]','[/list]','[img]','[/img]','[url]','[/url]');
imageTag = false;

// Shows the help messages in the helpline window
function helpline(help) {
	document.post.helpbox.value = eval(help + "_help");
}


// Replacement for arraygensmall.length property
function getarraysize(thearray) {
	for (i = 0; i < thearray.length; i++) {
		if ((thearray[i] == "undefined") || (thearray[i] == "") || (thearray[i] == null))
			return i;
		}
	return thearray.length;
}

// Replacement for arraygensmall.push(value) not implemented in IE until version 5.5
// Appends element to the array
function arraypush(thearray,value) {
	thearray[ getarraysize(thearray) ] = value;
}

// Replacement for arraygensmall.pop() not implemented in IE until version 5.5
// Removes and returns the last element of an array
function arraypop(thearray) {
	thearraysize = getarraysize(thearray);
	retval = thearray[thearraysize - 1];
	delete thearray[thearraysize - 1];
	return retval;
}


function checkForm() {

	formErrors = false;    

	if (document.post.message.value.length < 2) {
		formErrors = "{L_EMPTY_MESSAGE}";
	}

	if (formErrors) {
		alert(formErrors);
		return false;
	} else {
		bbstyle(-1);
		//formObj.preview.disabled = true;
		//formObj.submit.disabled = true;
		return true;
	}
}

function emoticon(text) {
	var txtarea = document.post.message;
	text = ' ' + text + ' ';
	if (txtarea.createTextRange && txtarea.caretPos) {
		var caretPos = txtarea.caretPos;
		caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == ' ' ? caretPos.text + text + ' ' : caretPos.text + text;
		txtarea.focus();
	} else {
		txtarea.value  += text;
		txtarea.focus();
	}
}

function bbfontstyle(bbopen, bbclose) {
	var txtarea = document.post.message;

	if ((clientVer >= 4) && is_ie && is_win) {
		theSelection = document.selection.createRange().text;
		if (!theSelection) {
			txtarea.value += bbopen + bbclose;
			txtarea.focus();
			return;
		}
		document.selection.createRange().text = bbopen + theSelection + bbclose;
		txtarea.focus();
		return;
	}
	else if (txtarea.selectionEnd && (txtarea.selectionEnd - txtarea.selectionStart > 0))
	{
		mozWrap(txtarea, bbopen, bbclose);
		return;
	}
	else
	{
		txtarea.value += bbopen + bbclose;
		txtarea.focus();
	}
	storeCaret(txtarea);
}


function bbstyle(bbnumber) {
	var txtarea = document.post.message;

	txtarea.focus();
	donotinsert = false;
	theSelection = false;
	bblast = 0;

	if (bbnumber == -1) { // Close all open tags & default button gensmalls
		while (bbcode[0]) {
			butnumber = arraypop(bbcode) - 1;
			txtarea.value += bbtags[butnumber + 1];
			buttext = eval('document.post.addbbcode' + butnumber + '.value');
			eval('document.post.addbbcode' + butnumber + '.value ="' + buttext.substr(0,(buttext.length - 1)) + '"');
		}
		imageTag = false; // All tags are closed including image tags :D
		txtarea.focus();
		return;
	}

	if ((clientVer >= 4) && is_ie && is_win)
	{
		theSelection = document.selection.createRange().text; // Get text selection
		if (theSelection) {
			// Add tags around selection
			document.selection.createRange().text = bbtags[bbnumber] + theSelection + bbtags[bbnumber+1];
			txtarea.focus();
			theSelection = '';
			return;
		}
	}
	else if (txtarea.selectionEnd && (txtarea.selectionEnd - txtarea.selectionStart > 0))
	{
		mozWrap(txtarea, bbtags[bbnumber], bbtags[bbnumber+1]);
		return;
	}
	
	// Find last occurance of an open tag the same as the one just clicked
	for (i = 0; i < bbcode.length; i++) {
		if (bbcode[i] == bbnumber+1) {
			bblast = i;
			donotinsert = true;
		}
	}

	if (donotinsert) {		// Close all open tags up to the one just clicked & default button gensmalls
		while (bbcode[bblast]) {
				butnumber = arraypop(bbcode) - 1;
				txtarea.value += bbtags[butnumber + 1];
				buttext = eval('document.post.addbbcode' + butnumber + '.value');
				eval('document.post.addbbcode' + butnumber + '.value ="' + buttext.substr(0,(buttext.length - 1)) + '"');
				imageTag = false;
			}
			txtarea.focus();
			return;
	} else { // Open tags
	
		if (imageTag && (bbnumber != 14)) {		// Close image tag before adding another
			txtarea.value += bbtags[15];
			lastValue = arraypop(bbcode) - 1;	// Remove the close image tag from the list
			document.post.addbbcode14.value = "Img";	// Return button back to normal state
			imageTag = false;
		}
		
		// Open tag
		txtarea.value += bbtags[bbnumber];
		if ((bbnumber == 14) && (imageTag == false)) imageTag = 1; // Check to stop additional tags after an unclosed image tag
		arraypush(bbcode,bbnumber+1);
		eval('document.post.addbbcode'+bbnumber+'.value += "*"');
		txtarea.focus();
		return;
	}
	storeCaret(txtarea);
}

// From http://www.massless.org/mozedit/
function mozWrap(txtarea, open, close)
{
	var selLength = txtarea.textLength;
	var selStart = txtarea.selectionStart;
	var selEnd = txtarea.selectionEnd;
	if (selEnd == 1 || selEnd == 2) 
		selEnd = selLength;

	var s1 = (txtarea.value).substring(0,selStart);
	var s2 = (txtarea.value).substring(selStart, selEnd)
	var s3 = (txtarea.value).substring(selEnd, selLength);
	txtarea.value = s1 + open + s2 + close + s3;
	return;
}

// Insert at Claret position. Code from
// http://www.faqts.com/knowledge_base/view.phtml/aid/1052/fid/130
function storeCaret(textEl) {
	if (textEl.createTextRange) textEl.caretPos = document.selection.createRange().duplicate();
}

//-->
</script>

<form action="{S_POST_ACTION}" method="post" name="post" onsubmit="return checkForm(this)">
<table cellspacing="1" class="posting_body">
	<tr>
		<td colspan="2" class="firstline"><a href="{U_INDEX}">{L_INDEX}</a>&nbsp;&nbsp;&raquo;&nbsp;&nbsp;<a href="{U_VIEW_FORUM}">{FORUM_NAME}</a></td>
	</tr>
	<tr>
		<td colspan="2" class="secondline">
			<div class="secondlinebuttons">&nbsp;<input type="image" src="{PRIVMSG_IMG}/preview-post.gif" name="preview" alt="{L_PREVIEW}" value="{L_PREVIEW}" />&nbsp;&nbsp;&nbsp;<input type="image" src="{PRIVMSG_IMG}/submit-post.gif" name="post" alt="{L_SUBMIT}" value="{L_SUBMIT}" accesskey="s" /></div>
			{SITENAME}&nbsp;&nbsp;&raquo;&nbsp;&nbsp;{PAGE_TITLE}</td>
	</tr>
	{POST_PREVIEW_BOX}
	<tr>
		<td colspan="2"><h2>{L_POST_A}</h2></td>
	</tr>
	{ERROR_BOX}
	<!-- BEGIN switch_username_select -->
	<tr> 
		<td class="row1 one">{L_USERNAME}:</td>
		<td class="row2 two"><input type="text" class="post postbig font11" tabindex="1" name="username" maxlength="25" value="{USERNAME}" /></td>
	</tr>
	<!-- END switch_username_select -->
	<!-- BEGIN switch_privmsg -->
	<tr> 
		<td class="row1 one">{L_USERNAME}:</td>
		<td class="row2 two"><input type="text" class="post postbig font11" name="username" maxlength="25" tabindex="1" value="{USERNAME}" />&nbsp;<input type="submit" name="usersubmit" value="{L_FIND_USERNAME}" class="button" onclick="window.open('{U_SEARCH_USER}', '_phpbbsearch', 'HEIGHT=250, resizable=yes, WIDTH=400'); return false;" /></td>
	</tr>
	<!-- END switch_privmsg -->
	<tr> 
		<td class="row1 one">{L_SUBJECT}:</td>
		<td class="row2 two"><input type="text" name="subject" maxlength="60" tabindex="2" class="post postbiggest font11" value="{SUBJECT}" /></td>
	</tr>
	<tr> 
		<td class="row1 three">{L_MESSAGE_BODY}<br />
			<div style="width: 100%; text-align: center; padding-top: 20px;">
				<table cellspacing="5" style="width: 100px; margin: 0 auto;">
					<tr> 
						<td colspan="{S_SMILIES_COLSPAN}" class="txtcenter">{L_EMOTICONS}</td>
					</tr>
					<!-- BEGIN smilies_row -->
					<tr class="txtmiddle"> 
						<!-- BEGIN smilies_col -->
						<td><a href="javascript:emoticon('{smilies_row.smilies_col.SMILEY_CODE}')"><img src="{smilies_row.smilies_col.SMILEY_IMG}" style="border: 0;" alt="{smilies_row.smilies_col.SMILEY_DESC}" title="{smilies_row.smilies_col.SMILEY_DESC}" /></a></td>
						<!-- END smilies_col -->
					</tr>
					<!-- END smilies_row -->
					<!-- BEGIN switch_smilies_extra -->
					<tr class="txtcenter"> 
						<td colspan="{S_SMILIES_COLSPAN}"><a href="{U_MORE_SMILIES}" onclick="window.open('{U_MORE_SMILIES}', '_phpbbsmilies', 'HEIGHT=300, resizable=yes, scrollbars=yes, WIDTH=250'); return false;" target="_phpbbsmilies">{L_MORE_SMILIES}</a></td>
					</tr>
					<!-- END switch_smilies_extra -->
				</table>
			</div>
		</td>
		<td class="row2 four">
			<div>
				<input type="button" class="button" accesskey="b" name="addbbcode0" value=" B " style="font-weight:bold; width: 30px" onclick="bbstyle(0)" onmouseover="helpline('b')" /> 
				<input type="button" class="button" accesskey="i" name="addbbcode2" value=" i " style="font-style:italic; width: 30px" onclick="bbstyle(2)" onmouseover="helpline('i')" />
				<input type="button" class="button" accesskey="u" name="addbbcode4" value="u" style="text-decoration: underline; width: 30px" onclick="bbstyle(4)" onmouseover="helpline('u')" />
				<input type="button" class="button" accesskey="q" name="addbbcode6" value="Quote" style="width: 50px" onclick="bbstyle(6)" onmouseover="helpline('q')" />
				<input type="button" class="button" accesskey="c" name="addbbcode8" value="Code" style="width: 40px" onclick="bbstyle(8)" onmouseover="helpline('c')" />
				<input type="button" class="button" accesskey="l" name="addbbcode10" value="List" style="width: 40px" onclick="bbstyle(10)" onmouseover="helpline('l')" />
				<input type="button" class="button" accesskey="o" name="addbbcode12" value="List=" style="width: 40px" onclick="bbstyle(12)" onmouseover="helpline('o')" />
				<input type="button" class="button" accesskey="p" name="addbbcode14" value="Img" style="width: 40px"  onclick="bbstyle(14)" onmouseover="helpline('p')" />
				<input type="button" class="button" accesskey="w" name="addbbcode16" value="URL" style="text-decoration: underline; width: 40px" onclick="bbstyle(16)" onmouseover="helpline('w')" />
				<input type="button" class="button" accesskey="w" name="addbbcode16" value="{L_BBCODE_CLOSE_TAGS}" onclick="bbstyle(-1)" onmouseover="helpline('a')" />
			</div>
			<div>
				{L_FONT_COLOR}: <select name="addbbcode18" onchange="bbfontstyle('[color=' + this.form.addbbcode18.options[this.form.addbbcode18.selectedIndex].value + ']', '[/color]');this.selectedIndex=0;" onmouseover="helpline('s')">
				<option style="color:black; background-color: {T_TD_COLOR1}" value="{T_FONTCOLOR1}">{L_COLOR_DEFAULT}</option>
				<option style="color:darkred; background-color: {T_TD_COLOR1}" value="darkred">{L_COLOR_DARK_RED}</option>
				<option style="color:red; background-color: {T_TD_COLOR1}" value="red">{L_COLOR_RED}</option>
				<option style="color:orange; background-color: {T_TD_COLOR1}" value="orange">{L_COLOR_ORANGE}</option>
				<option style="color:brown; background-color: {T_TD_COLOR1}" value="brown">{L_COLOR_BROWN}</option>
				<option style="color:yellow; background-color: {T_TD_COLOR1}" value="yellow">{L_COLOR_YELLOW}</option>
				<option style="color:green; background-color: {T_TD_COLOR1}" value="green">{L_COLOR_GREEN}</option>
				<option style="color:olive; background-color: {T_TD_COLOR1}" value="olive">{L_COLOR_OLIVE}</option>
				<option style="color:cyan; background-color: {T_TD_COLOR1}" value="cyan">{L_COLOR_CYAN}</option>
				<option style="color:blue; background-color: {T_TD_COLOR1}" value="blue">{L_COLOR_BLUE}</option>
				<option style="color:darkblue; background-color: {T_TD_COLOR1}" value="darkblue">{L_COLOR_DARK_BLUE}</option>
				<option style="color:indigo; background-color: {T_TD_COLOR1}" value="indigo">{L_COLOR_INDIGO}</option>
				<option style="color:violet; background-color: {T_TD_COLOR1}" value="violet">{L_COLOR_VIOLET}</option>
				<option style="color:white; background-color: {T_TD_COLOR1}" value="white">{L_COLOR_WHITE}</option>
				<option style="color:black; background-color: {T_TD_COLOR1}" value="black">{L_COLOR_BLACK}</option>
				</select>
				&nbsp;{L_FONT_SIZE}: <select name="addbbcode20" onchange="bbfontstyle('[size=' + this.form.addbbcode20.options[this.form.addbbcode20.selectedIndex].value + ']', '[/size]')" onmouseover="helpline('f')">
				<option value="8">{L_FONT_TINY}</option>
				<option value="9">{L_FONT_SMALL}</option>
				<option value="10" selected="selected">{L_FONT_NORMAL}</option>
				<option value="12">{L_FONT_LARGE}</option>
				<option  value="14">{L_FONT_HUGE}</option>
				</select>
			</div>
			<div>
				<input type="text" name="helpbox" maxlength="100" class="helpline postbiggest" value="{L_STYLES_TIP}" />
			</div>
			<textarea name="message" rows="15" cols="35" tabindex="3" class="post postbiggest font11" onselect="storeCaret(this);" onclick="storeCaret(this);" onkeyup="storeCaret(this);">{MESSAGE}</textarea>
		</td>
	</tr>
	<tr> 
		<td class="row1 three">{L_OPTIONS}:<br />{HTML_STATUS}<br />{BBCODE_STATUS}<br />{SMILIES_STATUS}</td>
		<td class="row2 four">
			<!-- BEGIN switch_html_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="disable_html" {S_HTML_CHECKED} /> {L_DISABLE_HTML}
			</div>
			<!-- END switch_html_checkbox -->
			<!-- BEGIN switch_bbcode_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="disable_bbcode" {S_BBCODE_CHECKED} /> {L_DISABLE_BBCODE}
			</div>
			<!-- END switch_bbcode_checkbox -->
			<!-- BEGIN switch_smilies_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="disable_smilies" {S_SMILIES_CHECKED} /> {L_DISABLE_SMILIES}
			</div>
			<!-- END switch_smilies_checkbox -->
			<!-- BEGIN switch_signature_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="attach_sig" {S_SIGNATURE_CHECKED} /> {L_ATTACH_SIGNATURE}
			</div>
			<!-- END switch_signature_checkbox -->
			<!-- BEGIN switch_notify_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="notify" {S_NOTIFY_CHECKED} /> {L_NOTIFY_ON_REPLY}
			</div>
			<!-- END switch_notify_checkbox -->
			<!-- BEGIN switch_delete_checkbox -->
			<div>
				<input type="checkbox" class="checkbox" name="delete" /> {L_DELETE_POST}
			</div>
			<!-- END switch_delete_checkbox -->
			<!-- BEGIN switch_type_toggle -->
			<div>
				{S_TYPE_TOGGLE}
			</div>
			<!-- END switch_type_toggle -->
		</td>
	</tr>
	{POLLBOX} 
	<tr> 
		<td class="row3" style="padding: 0" colspan="2"><table cellspacing="0">
			<tr>
				<td class="darkCornerL">&nbsp;</td>
				<td class="darkCornerR">&nbsp;</td>
			</tr>
		</table></td>	
	</tr>
</table>

<div class="bottombuttons">
	<div class="right">{S_HIDDEN_FORM_FIELDS}<input type="image" src="{PRIVMSG_IMG}/preview-post.gif" name="preview" alt="{L_PREVIEW}" value="{L_PREVIEW}"  />&nbsp;&nbsp;&nbsp;<input type="image" src="{PRIVMSG_IMG}/submit-post.gif" name="post" alt="{L_SUBMIT}" value="{L_SUBMIT}" accesskey="s" /></div>
	<div class="left">&nbsp;</div>
</div>
</form>

<div class="clear"></div>

<table cellspacing="0">
	<tr class="lines_2">
		<th>
		<div class="right">
			{S_TIMEZONE}<br />
			{CURRENT_TIME}
		</div>
		<div class="left">
			<span class="nav"><a href="{U_INDEX}">{L_INDEX}</a></span>
		</div>
		</th>
	</tr>
</table>

<div class="spacing"></div>

<div class="right">
	<table cellspacing="0" style="width: 100px;">
		<tr> 
			<td>{INBOX_IMG}</td>
			<td>{INBOX}&nbsp;&nbsp;</td>
			<td>{SENTBOX_IMG}</td>
			<td>{SENTBOX}&nbsp;&nbsp;</td>
			<td>{OUTBOX_IMG}</td>
			<td>{OUTBOX}&nbsp;&nbsp;</td>
			<td>{SAVEBOX_IMG}</td>
			<td>{SAVEBOX}</td>
		</tr>
	</table>
</div>
<div class="clear"></div>

{TOPIC_REVIEW_BOX} 