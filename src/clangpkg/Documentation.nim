## /*==-- clang-c/Documentation.h - Utilities for comment processing -*- C -*-===*\
## |*                                                                            *|
## |* Part of the LLVM Project, under the Apache License v2.0 with LLVM          *|
## |* Exceptions.                                                                *|
## |* See https://llvm.org/LICENSE.txt for license information.                  *|
## |* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception                    *|
## |*                                                                            *|
## |*===----------------------------------------------------------------------===*|
## |*                                                                            *|
## |* This header provides a supplementary interface for inspecting              *|
## |* documentation comments.                                                    *|
## |*                                                                            *|
## \*===----------------------------------------------------------------------===*/

import "Index.nim"
import "CXString.nim"

## *
##  \defgroup CINDEX_COMMENT Comment introspection
##
##  The routines in this group provide access to information in documentation
##  comments. These facilities are distinct from the core and may be subject to
##  their own schedule of stability and deprecation.
##
##  @{
##
## *
##  A parsed comment.
##

type
  CXComment* {.bycopy.} = object
    ASTNode*: pointer
    TranslationUnit*: CXTranslationUnit


## *
##  Given a cursor that represents a documentable entity (e.g.,
##  declaration),  the associated parsed comment as a
##  \c CXComment_FullComment AST node.
##

proc Cursor_getParsedComment*(C: CXCursor): CXComment {.
    importc: "clang_Cursor_getParsedComment", cdecl.}
## *
##  Describes the type of the comment AST node (\c CXComment).  A comment
##  node can be considered block content (e. g., paragraph), inline content
##  (plain text) or neither (the root AST node).
##

type ## *
    ##  Null comment.  No AST node is constructed at the requested location
    ##  because there is no text or a syntax error.
    ##
  CXCommentKind* {.size: sizeof(cint).} = enum
    CXComment_Null = 0,         ## *
                     ##  Plain text.  Inline content.
                     ##
    CXComment_Text = 1, ## *
                     ##  A command with word-like arguments that is considered inline content.
                     ##
                     ##  For example: \\c command.
                     ##
    CXComment_InlineCommand = 2, ## *
                              ##  HTML start tag with attributes (name-value pairs).  Considered
                              ##  inline content.
                              ##
                              ##  For example:
                              ##  \verbatim
                              ##  <br> <br /> <a href="http://example.org/">
                              ##  \endverbatim
                              ##
    CXComment_HTMLStartTag = 3, ## *
                             ##  HTML end tag.  Considered inline content.
                             ##
                             ##  For example:
                             ##  \verbatim
                             ##  </a>
                             ##  \endverbatim
                             ##
    CXComment_HTMLEndTag = 4, ## *
                           ##  A paragraph, contains inline comment.  The paragraph itself is
                           ##  block content.
                           ##
    CXComment_Paragraph = 5, ## *
                          ##  A command that has zero or more word-like arguments (number of
                          ##  word-like arguments depends on command name) and a paragraph as an
                          ##  argument.  Block command is block content.
                          ##
                          ##  Paragraph argument is also a child of the block command.
                          ##
                          ##  For example: \has 0 word-like arguments and a paragraph argument.
                          ##
                          ##  AST nodes of special kinds that parser knows about (e. g., \\param
                          ##  command) have their own node kinds.
                          ##
    CXComment_BlockCommand = 6, ## *
                             ##  A \\param or \\arg command that describes the function parameter
                             ##  (name, passing direction, description).
                             ##
                             ##  For example: \\param [in] ParamName description.
                             ##
    CXComment_ParamCommand = 7, ## *
                             ##  A \\tparam command that describes a template parameter (name and
                             ##  description).
                             ##
                             ##  For example: \\tparam T description.
                             ##
    CXComment_TParamCommand = 8, ## *
                              ##  A verbatim block command (e. g., preformatted code).  Verbatim
                              ##  block has an opening and a closing command and contains multiple lines of
                              ##  text (\c CXComment_VerbatimBlockLine child nodes).
                              ##
                              ##  For example:
                              ##  \\verbatim
                              ##  aaa
                              ##  \\endverbatim
                              ##
    CXComment_VerbatimBlockCommand = 9, ## *
                                     ##  A line of text that is contained within a
                                     ##  CXComment_VerbatimBlockCommand node.
                                     ##
    CXComment_VerbatimBlockLine = 10, ## *
                                   ##  A verbatim line command.  Verbatim line has an opening command,
                                   ##  a single line of text (up to the newline after the opening command) and
                                   ##  has no closing command.
                                   ##
    CXComment_VerbatimLine = 11, ## *
                              ##  A full comment attached to a declaration, contains block content.
                              ##
    CXComment_FullComment = 12


## *
##  The most appropriate rendering mode for an inline command, chosen on
##  command semantics in Doxygen.
##

type ## *
    ##  Command argument should be rendered in a normal font.
    ##
  CXCommentInlineCommandRenderKind* {.size: sizeof(cint).} = enum
    CXCommentInlineCommandRenderKind_Normal, ## *
                                            ##  Command argument should be rendered in a bold font.
                                            ##
    CXCommentInlineCommandRenderKind_Bold, ## *
                                          ##  Command argument should be rendered in a monospaced font.
                                          ##
    CXCommentInlineCommandRenderKind_Monospaced, ## *
                                                ##  Command argument should be rendered emphasized (typically italic
                                                ##  font).
                                                ##
    CXCommentInlineCommandRenderKind_Emphasized, ## *
                                                ##  Command argument should not be rendered (since it only defines an anchor).
                                                ##
    CXCommentInlineCommandRenderKind_Anchor


## *
##  Describes parameter passing direction for \\param or \\arg command.
##

type                          ## *
    ##  The parameter is an input parameter.
    ##
  CXCommentParamPassDirection* {.size: sizeof(cint).} = enum
    CXCommentParamPassDirection_In, ## *
                                   ##  The parameter is an output parameter.
                                   ##
    CXCommentParamPassDirection_Out, ## *
                                    ##  The parameter is an input and output parameter.
                                    ##
    CXCommentParamPassDirection_InOut


## *
##  \param Comment AST node of any kind.
##
##  \s the type of the AST node.
##

proc Comment_getKind*(Comment: CXComment): CXCommentKind {.
    importc: "clang_Comment_getKind", cdecl.}
## *
##  \param Comment AST node of any kind.
##
##  \s number of children of the AST node.
##

proc Comment_getNumChildren*(Comment: CXComment): cuint {.
    importc: "clang_Comment_getNumChildren", cdecl.}
## *
##  \param Comment AST node of any kind.
##
##  \param ChildIdx child index (zero-based).
##
##  \s the specified child of the AST node.
##

proc Comment_getChild*(Comment: CXComment; ChildIdx: cuint): CXComment {.
    importc: "clang_Comment_getChild", cdecl.}
## *
##  A \c CXComment_Paragraph node is considered whitespace if it contains
##  only \c CXComment_Text nodes that are empty or whitespace.
##
##  Other AST nodes (except \c CXComment_Paragraph and \c CXComment_Text) are
##  never considered whitespace.
##
##  \s non-zero if \c Comment is whitespace.
##

proc Comment_isWhitespace*(Comment: CXComment): cuint {.
    importc: "clang_Comment_isWhitespace", cdecl.}
## *
##  \s non-zero if \c Comment is inline content and has a newline
##  immediately following it in the comment text.  Newlines between paragraphs
##  do not count.
##

proc InlineContentComment_hasTrailingNewline*(Comment: CXComment): cuint {.
    importc: "clang_InlineContentComment_hasTrailingNewline", cdecl.}
## *
##  \param Comment a \c CXComment_Text AST node.
##
##  \s text contained in the AST node.
##

proc TextComment_getText*(Comment: CXComment): CXString {.
    importc: "clang_TextComment_getText", cdecl.}
## *
##  \param Comment a \c CXComment_InlineCommand AST node.
##
##  \s name of the inline command.
##

proc InlineCommandComment_getCommandName*(Comment: CXComment): CXString {.
    importc: "clang_InlineCommandComment_getCommandName", cdecl.}
## *
##  \param Comment a \c CXComment_InlineCommand AST node.
##
##  \s the most appropriate rendering mode, chosen on command
##  semantics in Doxygen.
##

proc InlineCommandComment_getRenderKind*(Comment: CXComment): CXCommentInlineCommandRenderKind {.
    importc: "clang_InlineCommandComment_getRenderKind", cdecl.}
## *
##  \param Comment a \c CXComment_InlineCommand AST node.
##
##  \s number of command arguments.
##

proc InlineCommandComment_getNumArgs*(Comment: CXComment): cuint {.
    importc: "clang_InlineCommandComment_getNumArgs", cdecl.}
## *
##  \param Comment a \c CXComment_InlineCommand AST node.
##
##  \param ArgIdx argument index (zero-based).
##
##  \s text of the specified argument.
##

proc InlineCommandComment_getArgText*(Comment: CXComment; ArgIdx: cuint): CXString {.
    importc: "clang_InlineCommandComment_getArgText", cdecl.}
## *
##  \param Comment a \c CXComment_HTMLStartTag or \c CXComment_HTMLEndTag AST
##  node.
##
##  \s HTML tag name.
##

proc HTMLTagComment_getTagName*(Comment: CXComment): CXString {.
    importc: "clang_HTMLTagComment_getTagName", cdecl.}
## *
##  \param Comment a \c CXComment_HTMLStartTag AST node.
##
##  \s non-zero if tag is self-closing (for example, &lt;br /&gt;).
##

proc HTMLStartTagComment_isSelfClosing*(Comment: CXComment): cuint {.
    importc: "clang_HTMLStartTagComment_isSelfClosing", cdecl.}
## *
##  \param Comment a \c CXComment_HTMLStartTag AST node.
##
##  \s number of attributes (name-value pairs) attached to the start tag.
##

proc HTMLStartTag_getNumAttrs*(Comment: CXComment): cuint {.
    importc: "clang_HTMLStartTag_getNumAttrs", cdecl.}
## *
##  \param Comment a \c CXComment_HTMLStartTag AST node.
##
##  \param AttrIdx attribute index (zero-based).
##
##  \s name of the specified attribute.
##

proc HTMLStartTag_getAttrName*(Comment: CXComment; AttrIdx: cuint): CXString {.
    importc: "clang_HTMLStartTag_getAttrName", cdecl.}
## *
##  \param Comment a \c CXComment_HTMLStartTag AST node.
##
##  \param AttrIdx attribute index (zero-based).
##
##  \s value of the specified attribute.
##

proc HTMLStartTag_getAttrValue*(Comment: CXComment; AttrIdx: cuint): CXString {.
    importc: "clang_HTMLStartTag_getAttrValue", cdecl.}
## *
##  \param Comment a \c CXComment_BlockCommand AST node.
##
##  \s name of the block command.
##

proc BlockCommandComment_getCommandName*(Comment: CXComment): CXString {.
    importc: "clang_BlockCommandComment_getCommandName", cdecl.}
## *
##  \param Comment a \c CXComment_BlockCommand AST node.
##
##  \s number of word-like arguments.
##

proc BlockCommandComment_getNumArgs*(Comment: CXComment): cuint {.
    importc: "clang_BlockCommandComment_getNumArgs", cdecl.}
## *
##  \param Comment a \c CXComment_BlockCommand AST node.
##
##  \param ArgIdx argument index (zero-based).
##
##  \s text of the specified word-like argument.
##

proc BlockCommandComment_getArgText*(Comment: CXComment; ArgIdx: cuint): CXString {.
    importc: "clang_BlockCommandComment_getArgText", cdecl.}
## *
##  \param Comment a \c CXComment_BlockCommand or
##  \c CXComment_VerbatimBlockCommand AST node.
##
##  \s paragraph argument of the block command.
##

proc BlockCommandComment_getParagraph*(Comment: CXComment): CXComment {.
    importc: "clang_BlockCommandComment_getParagraph", cdecl.}
## *
##  \param Comment a \c CXComment_ParamCommand AST node.
##
##  \s parameter name.
##

proc ParamCommandComment_getParamName*(Comment: CXComment): CXString {.
    importc: "clang_ParamCommandComment_getParamName", cdecl.}
## *
##  \param Comment a \c CXComment_ParamCommand AST node.
##
##  \s non-zero if the parameter that this AST node represents was found
##  in the function prototype and \c clang_ParamCommandComment_getParamIndex
##  function will  a meaningful value.
##

proc ParamCommandComment_isParamIndexValid*(Comment: CXComment): cuint {.
    importc: "clang_ParamCommandComment_isParamIndexValid", cdecl.}
## *
##  \param Comment a \c CXComment_ParamCommand AST node.
##
##  \s zero-based parameter index in function prototype.
##

proc ParamCommandComment_getParamIndex*(Comment: CXComment): cuint {.
    importc: "clang_ParamCommandComment_getParamIndex", cdecl.}
## *
##  \param Comment a \c CXComment_ParamCommand AST node.
##
##  \s non-zero if parameter passing direction was specified explicitly in
##  the comment.
##

proc ParamCommandComment_isDirectionExplicit*(Comment: CXComment): cuint {.
    importc: "clang_ParamCommandComment_isDirectionExplicit", cdecl.}
## *
##  \param Comment a \c CXComment_ParamCommand AST node.
##
##  \s parameter passing direction.
##

proc ParamCommandComment_getDirection*(Comment: CXComment): CXCommentParamPassDirection {.
    importc: "clang_ParamCommandComment_getDirection", cdecl.}
## *
##  \param Comment a \c CXComment_TParamCommand AST node.
##
##  \s template parameter name.
##

proc TParamCommandComment_getParamName*(Comment: CXComment): CXString {.
    importc: "clang_TParamCommandComment_getParamName", cdecl.}
## *
##  \param Comment a \c CXComment_TParamCommand AST node.
##
##  \s non-zero if the parameter that this AST node represents was found
##  in the template parameter list and
##  \c clang_TParamCommandComment_getDepth and
##  \c clang_TParamCommandComment_getIndex functions will  a meaningful
##  value.
##

proc TParamCommandComment_isParamPositionValid*(Comment: CXComment): cuint {.
    importc: "clang_TParamCommandComment_isParamPositionValid", cdecl.}
## *
##  \param Comment a \c CXComment_TParamCommand AST node.
##
##  \s zero-based nesting depth of this parameter in the template parameter list.
##
##  For example,
##  \verbatim
##      template<typename C, template<typename T> class TT>
##      void test(TT<int> aaa);
##  \endverbatim
##  for C and TT nesting depth is 0,
##  for T nesting depth is 1.
##

proc TParamCommandComment_getDepth*(Comment: CXComment): cuint {.
    importc: "clang_TParamCommandComment_getDepth", cdecl.}
## *
##  \param Comment a \c CXComment_TParamCommand AST node.
##
##  \s zero-based parameter index in the template parameter list at a
##  given nesting depth.
##
##  For example,
##  \verbatim
##      template<typename C, template<typename T> class TT>
##      void test(TT<int> aaa);
##  \endverbatim
##  for C and TT nesting depth is 0, so we can ask for index at depth 0:
##  at depth 0 C's index is 0, TT's index is 1.
##
##  For T nesting depth is 1, so we can ask for index at depth 0 and 1:
##  at depth 0 T's index is 1 (same as TT's),
##  at depth 1 T's index is 0.
##

proc TParamCommandComment_getIndex*(Comment: CXComment; Depth: cuint): cuint {.
    importc: "clang_TParamCommandComment_getIndex", cdecl.}
## *
##  \param Comment a \c CXComment_VerbatimBlockLine AST node.
##
##  \s text contained in the AST node.
##

proc VerbatimBlockLineComment_getText*(Comment: CXComment): CXString {.
    importc: "clang_VerbatimBlockLineComment_getText", cdecl.}
## *
##  \param Comment a \c CXComment_VerbatimLine AST node.
##
##  \s text contained in the AST node.
##

proc VerbatimLineComment_getText*(Comment: CXComment): CXString {.
    importc: "clang_VerbatimLineComment_getText", cdecl.}
## *
##  Convert an HTML tag AST node to string.
##
##  \param Comment a \c CXComment_HTMLStartTag or \c CXComment_HTMLEndTag AST
##  node.
##
##  \s string containing an HTML tag.
##

proc HTMLTagComment_getAsString*(Comment: CXComment): CXString {.
    importc: "clang_HTMLTagComment_getAsString", cdecl.}
## *
##  Convert a given full parsed comment to an HTML fragment.
##
##  Specific details of HTML layout are subject to change.  Don't try to parse
##  this HTML back into an AST, use other APIs instead.
##
##  Currently the following CSS classes are used:
##  \li "para-brief" for \paragraph and equivalent commands;
##  \li "para-s" for \\s paragraph and equivalent commands;
##  \li "word-s" for the "s" word in \\s paragraph.
##
##  Function argument documentation is rendered as a \<dl\> list with arguments
##  sorted in function prototype order.  CSS classes used:
##  \li "param-name-index-NUMBER" for parameter name (\<dt\>);
##  \li "param-descr-index-NUMBER" for parameter description (\<dd\>);
##  \li "param-name-index-invalid" and "param-descr-index-invalid" are used if
##  parameter index is invalid.
##
##  Template parameter documentation is rendered as a \<dl\> list with
##  parameters sorted in template parameter list order.  CSS classes used:
##  \li "tparam-name-index-NUMBER" for parameter name (\<dt\>);
##  \li "tparam-descr-index-NUMBER" for parameter description (\<dd\>);
##  \li "tparam-name-index-other" and "tparam-descr-index-other" are used for
##  names inside template template parameters;
##  \li "tparam-name-index-invalid" and "tparam-descr-index-invalid" are used if
##  parameter position is invalid.
##
##  \param Comment a \c CXComment_FullComment AST node.
##
##  \s string containing an HTML fragment.
##

proc FullComment_getAsHTML*(Comment: CXComment): CXString {.
    importc: "clang_FullComment_getAsHTML", cdecl.}
## *
##  Convert a given full parsed comment to an XML document.
##
##  A Relax NG schema for the XML can be found in comment-xml-schema.rng file
##  inside clang source tree.
##
##  \param Comment a \c CXComment_FullComment AST node.
##
##  \s string containing an XML document.
##

proc FullComment_getAsXML*(Comment: CXComment): CXString {.
    importc: "clang_FullComment_getAsXML", cdecl.}
## *
##  @}
##
