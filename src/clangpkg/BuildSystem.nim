## /*==-- clang-c/BuildSystem.h - Utilities for use by build systems -*- C -*-===*\
## |*                                                                            *|
## |* Part of the LLVM Project, under the Apache License v2.0 with LLVM          *|
## |* Exceptions.                                                                *|
## |* See https://llvm.org/LICENSE.txt for license information.                  *|
## |* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception                    *|
## |*                                                                            *|
## |*===----------------------------------------------------------------------===*|
## |*                                                                            *|
## |* This header provides various utilities for use by build systems.           *|
## |*                                                                            *|
## \*===----------------------------------------------------------------------===*/

import "CXErrorCode.nim"
import "CXString.nim"

## *
##  \defgroup BUILD_SYSTEM Build system utilities
##  @{
##
## *
##  Return the timestamp for use with Clang's
##  \c -fbuild-session-timestamp= option.
##

proc getBuildSessionTimestamp*(): culonglong {.
    importc: "clang_getBuildSessionTimestamp", cdecl.}
## *
##  Object encapsulating information about overlaying virtual
##  file/directories over the real file system.
##

type
  CXVirtualFileOverlay* = pointer # CXVirtualFileOverlayImpl

## *
##  Create a \c CXVirtualFileOverlay object.
##  Must be disposed with \c clang_VirtualFileOverlay_dispose().
##
##  \param options is reserved, always pass 0.
##

proc VirtualFileOverlay_create*(options: cuint): CXVirtualFileOverlay {.
    importc: "clang_VirtualFileOverlay_create", cdecl.}
## *
##  Map an absolute virtual file path to an absolute real one.
##  The virtual path must be canonicalized (not contain "."/"..").
##  \returns 0 for success, non-zero to indicate an error.
##

proc VirtualFileOverlay_addFileMapping*(a1: CXVirtualFileOverlay;
                                       virtualPath: cstring; realPath: cstring): CXErrorCode {.
    importc: "clang_VirtualFileOverlay_addFileMapping", cdecl.}
## *
##  Set the case sensitivity for the \c CXVirtualFileOverlay object.
##  The \c CXVirtualFileOverlay object is case-sensitive by default, this
##  option can be used to override the default.
##  \returns 0 for success, non-zero to indicate an error.
##

proc VirtualFileOverlay_setCaseSensitivity*(a1: CXVirtualFileOverlay;
    caseSensitive: cint): CXErrorCode {.importc: "clang_VirtualFileOverlay_setCaseSensitivity",
                                     cdecl.}
## *
##  Write out the \c CXVirtualFileOverlay object to a char buffer.
##
##  \param options is reserved, always pass 0.
##  \param out_buffer_ptr pointer to receive the buffer pointer, which should be
##  disposed using \c clang_free().
##  \param out_buffer_size pointer to receive the buffer size.
##  \returns 0 for success, non-zero to indicate an error.
##

proc VirtualFileOverlay_writeToBuffer*(a1: CXVirtualFileOverlay; options: cuint;
                                      out_buffer_ptr: cstringArray;
                                      out_buffer_size: ptr cuint): CXErrorCode {.
    importc: "clang_VirtualFileOverlay_writeToBuffer", cdecl.}
## *
##  free memory allocated by libclang, such as the buffer returned by
##  \c CXVirtualFileOverlay() or \c clang_ModuleMapDescriptor_writeToBuffer().
##
##  \param buffer memory pointer to free.
##

proc free*(buffer: pointer) {.importc: "clang_free", cdecl.}
## *
##  Dispose a \c CXVirtualFileOverlay object.
##

proc VirtualFileOverlay_dispose*(a1: CXVirtualFileOverlay) {.
    importc: "clang_VirtualFileOverlay_dispose", cdecl.}
## *
##  Object encapsulating information about a module.map file.
##

type
  CXModuleMapDescriptor* = pointer # CXModuleMapDescriptorImpl

## *
##  Create a \c CXModuleMapDescriptor object.
##  Must be disposed with \c clang_ModuleMapDescriptor_dispose().
##
##  \param options is reserved, always pass 0.
##

proc ModuleMapDescriptor_create*(options: cuint): CXModuleMapDescriptor {.
    importc: "clang_ModuleMapDescriptor_create", cdecl.}
## *
##  Sets the framework module name that the module.map describes.
##  \returns 0 for success, non-zero to indicate an error.
##

proc ModuleMapDescriptor_setFrameworkModuleName*(a1: CXModuleMapDescriptor;
    name: cstring): CXErrorCode {.importc: "clang_ModuleMapDescriptor_setFrameworkModuleName",
                               cdecl.}
## *
##  Sets the umbrealla header name that the module.map describes.
##  \returns 0 for success, non-zero to indicate an error.
##

proc ModuleMapDescriptor_setUmbrellaHeader*(a1: CXModuleMapDescriptor;
    name: cstring): CXErrorCode {.importc: "clang_ModuleMapDescriptor_setUmbrellaHeader",
                               cdecl.}
## *
##  Write out the \c CXModuleMapDescriptor object to a char buffer.
##
##  \param options is reserved, always pass 0.
##  \param out_buffer_ptr pointer to receive the buffer pointer, which should be
##  disposed using \c clang_free().
##  \param out_buffer_size pointer to receive the buffer size.
##  \returns 0 for success, non-zero to indicate an error.
##

proc ModuleMapDescriptor_writeToBuffer*(a1: CXModuleMapDescriptor; options: cuint;
                                       out_buffer_ptr: cstringArray;
                                       out_buffer_size: ptr cuint): CXErrorCode {.
    importc: "clang_ModuleMapDescriptor_writeToBuffer", cdecl.}
## *
##  Dispose a \c CXModuleMapDescriptor object.
##

proc ModuleMapDescriptor_dispose*(a1: CXModuleMapDescriptor) {.
    importc: "clang_ModuleMapDescriptor_dispose", cdecl.}
## *
##  @}
##
