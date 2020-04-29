## /*===-- clang-c/CXCompilationDatabase.h - Compilation database  ---*- C -*-===*\
## |*                                                                            *|
## |* Part of the LLVM Project, under the Apache License v2.0 with LLVM          *|
## |* Exceptions.                                                                *|
## |* See https://llvm.org/LICENSE.txt for license information.                  *|
## |* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception                    *|
## |*                                                                            *|
## |*===----------------------------------------------------------------------===*|
## |*                                                                            *|
## |* This header provides a public interface to use CompilationDatabase without *|
## |* the full Clang C++ API.                                                    *|
## |*                                                                            *|
## \*===----------------------------------------------------------------------===*/

import "CXString.nim"

## * \defgroup COMPILATIONDB CompilationDatabase functions
##  \ingroup CINDEX
##
##  @{
##
## *
##  A compilation database holds all information used to compile files in a
##  project. For each file in the database, it can be queried for the working
##  directory or the command line used for the compiler invocation.
##
##  Must be freed by \c clang_CompilationDatabase_dispose
##

type
  CXCompilationDatabase* = pointer

## *
##  Contains the results of a search in the compilation database
##
##  When searching for the compile command for a file, the compilation db can
##  return several commands, as the file may have been compiled with
##  different options in different places of the project. This choice of compile
##  commands is wrapped in this opaque data structure. It must be freed by
##  \c clang_CompileCommands_dispose.
##

type
  CXCompileCommands* = pointer

## *
##  Represents the command line invocation to compile a specific file.
##

type
  CXCompileCommand* = pointer

## *
##  Error codes for Compilation Database
##

type                          ##
    ##  No error occurred
    ##
  CXCompilationDatabase_Error* {.size: sizeof(cint).} = enum
    CXCompilationDatabase_NoError = 0, ##
                                    ##  Database can not be loaded
                                    ##
    CXCompilationDatabase_CanNotLoadDatabase = 1


## *
##  Creates a compilation database from the database found in directory
##  buildDir. For example, CMake can output a compile_commands.json which can
##  be used to build the database.
##
##  It must be freed by \c clang_CompilationDatabase_dispose.
##

proc CompilationDatabase_fromDirectory*(BuildDir: cstring; ErrorCode: ptr CXCompilationDatabase_Error): CXCompilationDatabase {.
    importc: "clang_CompilationDatabase_fromDirectory", cdecl.}
## *
##  Free the given compilation database
##

proc CompilationDatabase_dispose*(a1: CXCompilationDatabase) {.
    importc: "clang_CompilationDatabase_dispose", cdecl.}
## *
##  Find the compile commands used for a file. The compile commands
##  must be freed by \c clang_CompileCommands_dispose.
##

proc CompilationDatabase_getCompileCommands*(a1: CXCompilationDatabase;
    CompleteFileName: cstring): CXCompileCommands {.
    importc: "clang_CompilationDatabase_getCompileCommands", cdecl.}
## *
##  Get all the compile commands in the given compilation database.
##

proc CompilationDatabase_getAllCompileCommands*(a1: CXCompilationDatabase): CXCompileCommands {.
    importc: "clang_CompilationDatabase_getAllCompileCommands", cdecl.}
## *
##  Free the given CompileCommands
##

proc CompileCommands_dispose*(a1: CXCompileCommands) {.
    importc: "clang_CompileCommands_dispose", cdecl.}
## *
##  Get the number of CompileCommand we have for a file
##

proc CompileCommands_getSize*(a1: CXCompileCommands): cuint {.
    importc: "clang_CompileCommands_getSize", cdecl.}
## *
##  Get the I'th CompileCommand for a file
##
##  Note : 0 <= i < clang_CompileCommands_getSize(CXCompileCommands)
##

proc CompileCommands_getCommand*(a1: CXCompileCommands; I: cuint): CXCompileCommand {.
    importc: "clang_CompileCommands_getCommand", cdecl.}
## *
##  Get the working directory where the CompileCommand was executed from
##

proc CompileCommand_getDirectory*(a1: CXCompileCommand): CXString {.
    importc: "clang_CompileCommand_getDirectory", cdecl.}
## *
##  Get the filename associated with the CompileCommand.
##

proc CompileCommand_getFilename*(a1: CXCompileCommand): CXString {.
    importc: "clang_CompileCommand_getFilename", cdecl.}
## *
##  Get the number of arguments in the compiler invocation.
##
##

proc CompileCommand_getNumArgs*(a1: CXCompileCommand): cuint {.
    importc: "clang_CompileCommand_getNumArgs", cdecl.}
## *
##  Get the I'th argument value in the compiler invocations
##
##  Invariant :
##   - argument 0 is the compiler executable
##

proc CompileCommand_getArg*(a1: CXCompileCommand; I: cuint): CXString {.
    importc: "clang_CompileCommand_getArg", cdecl.}
## *
##  Get the number of source mappings for the compiler invocation.
##

proc CompileCommand_getNumMappedSources*(a1: CXCompileCommand): cuint {.
    importc: "clang_CompileCommand_getNumMappedSources", cdecl.}
## *
##  Get the I'th mapped source path for the compiler invocation.
##

proc CompileCommand_getMappedSourcePath*(a1: CXCompileCommand; I: cuint): CXString {.
    importc: "clang_CompileCommand_getMappedSourcePath", cdecl.}
## *
##  Get the I'th mapped source content for the compiler invocation.
##

proc CompileCommand_getMappedSourceContent*(a1: CXCompileCommand; I: cuint): CXString {.
    importc: "clang_CompileCommand_getMappedSourceContent", cdecl.}
## *
##  @}
##
