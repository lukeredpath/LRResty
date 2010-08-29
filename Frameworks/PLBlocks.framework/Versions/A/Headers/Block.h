/*
 * Copyright 2008 - 2009 Apple, Inc.
 * Copyright 2009 - 2010 Plausible Labs Cooperative, Inc.
 *
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge,
 * to any person obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/**
 * @defgroup functions Functions Reference
 */

/**
 * @internal
 * @defgroup private_api Private API Reference
 */

/**
 * @defgroup private_api_constants Constants
 * @ingroup private_api
 */

/**
 * @defgroup constants Constants Reference
 */

/**
 * @defgroup types Types Reference
 */

/**
 * @defgroup enums Enumerations
 * @ingroup constants
 */

/**
 * @defgroup globals Global Variables
 * @ingroup constants
 */

/**
 * @defgroup exceptions Exceptions
 * @ingroup constants
 */

#ifndef _PLBLOCK_H_
#define _PLBLOCK_H_

#if !defined(BLOCK_EXPORT)
#   if defined(__cplusplus)
#       define BLOCK_EXPORT extern "C" 
#   else
#       define BLOCK_EXPORT extern
#   endif
#endif

#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

/* Compatibility defines. Using the PLBlock_* variants instead is recommended. */
#undef Block_copy
#define Block_copy(...) ((__typeof(__VA_ARGS__))_PLBlock_copy((const void *)(__VA_ARGS__)))

#undef Block_release
#define Block_release(...) _PLBlock_release((const void *)(__VA_ARGS__))

#if __cplusplus
extern "C" {
#endif
    
    // Create a heap based copy of a Block or simply add a reference to an existing one.
    // This must be paired with Block_release to recover memory, even when running
    // under Objective-C Garbage Collection.
    BLOCK_EXPORT void *_PLBlock_copy(const void *aBlock);
    
    // Lose the reference, and if heap based and last reference, recover the memory
    BLOCK_EXPORT void _PLBlock_release(const void *aBlock);
    
#if __cplusplus
}
#endif

// Type correct macros

/**
 * @ingroup functions
 * @{
 */

/**
 * Copy a a stack-allocated block.
 */
#define PLBlock_copy(...) ((__typeof(__VA_ARGS__))_PLBlock_copy((const void *)(__VA_ARGS__)))

/**
 * Release a block instance.
 */
#define PLBlock_release(...) _PLBlock_release((const void *)(__VA_ARGS__))

/**
 * @} functions
 */

#endif /* _PLBLOCK_H_ */
