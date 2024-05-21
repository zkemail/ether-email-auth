pub use email_auth::*;
/// This module was auto-generated with ethers-rs Abigen.
/// More information at: <https://github.com/gakonst/ethers-rs>
#[allow(
    clippy::enum_variant_names,
    clippy::too_many_arguments,
    clippy::upper_case_acronyms,
    clippy::type_complexity,
    dead_code,
    non_camel_case_types,
)]
pub mod email_auth {
    #[allow(deprecated)]
    fn __abi() -> ::ethers::core::abi::Abi {
        ::ethers::core::abi::ethabi::Contract {
            constructor: ::core::option::Option::Some(::ethers::core::abi::ethabi::Constructor {
                inputs: ::std::vec![],
            }),
            functions: ::core::convert::From::from([
                (
                    ::std::borrow::ToOwned::to_owned("UPGRADE_INTERFACE_VERSION"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "UPGRADE_INTERFACE_VERSION",
                            ),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::String,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("accountSalt"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("accountSalt"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("authEmail"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("authEmail"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("emailAuthMsg"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Tuple(
                                        ::std::vec![
                                            ::ethers::core::abi::ethabi::ParamType::Uint(256usize),
                                            ::ethers::core::abi::ethabi::ParamType::Array(
                                                ::std::boxed::Box::new(
                                                    ::ethers::core::abi::ethabi::ParamType::Bytes,
                                                ),
                                            ),
                                            ::ethers::core::abi::ethabi::ParamType::Uint(256usize),
                                            ::ethers::core::abi::ethabi::ParamType::Tuple(
                                                ::std::vec![
                                                    ::ethers::core::abi::ethabi::ParamType::String,
                                                    ::ethers::core::abi::ethabi::ParamType::FixedBytes(32usize),
                                                    ::ethers::core::abi::ethabi::ParamType::Uint(256usize),
                                                    ::ethers::core::abi::ethabi::ParamType::String,
                                                    ::ethers::core::abi::ethabi::ParamType::FixedBytes(32usize),
                                                    ::ethers::core::abi::ethabi::ParamType::FixedBytes(32usize),
                                                    ::ethers::core::abi::ethabi::ParamType::Bool,
                                                    ::ethers::core::abi::ethabi::ParamType::Bytes,
                                                ],
                                            ),
                                        ],
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("struct EmailAuthMsg"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("authedHash"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("authedHash"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("computeMsgHash"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("computeMsgHash"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_accountSalt"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_isCodeExist"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bool"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_subjectParams"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::Bytes,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes[]"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Pure,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("deleteSubjectTemplate"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "deleteSubjectTemplate",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("dkim"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("dkim"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned(
                                            "contract ECDSAOwnedDKIMRegistry",
                                        ),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("dkimRegistryAddr"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("dkimRegistryAddr"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("getSubjectTemplate"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("getSubjectTemplate"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::String,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string[]"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("initialize"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("initialize"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_initialOwner"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_accountSalt"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("insertSubjectTemplate"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "insertSubjectTemplate",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_subjectTemplate"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::String,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string[]"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("isValidSignature"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("isValidSignature"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_hash"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_signature"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bytes,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        4usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes4"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("lastTimestamp"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("lastTimestamp"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("owner"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("owner"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("proxiableUUID"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("proxiableUUID"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("renounceOwnership"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("renounceOwnership"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("setTimestampCheckEnabled"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "setTimestampCheckEnabled",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_enabled"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bool"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("subjectTemplates"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("subjectTemplates"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::String,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("timestampCheckEnabled"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "timestampCheckEnabled",
                            ),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bool"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("transferOwnership"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("transferOwnership"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("newOwner"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("updateDKIMRegistry"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("updateDKIMRegistry"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_dkimRegistryAddr"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("updateSubjectTemplate"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "updateSubjectTemplate",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_subjectTemplate"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::String,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string[]"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("updateVerifier"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("updateVerifier"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_verifierAddr"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("upgradeToAndCall"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("upgradeToAndCall"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("newImplementation"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("data"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bytes,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Payable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("usedNullifiers"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("usedNullifiers"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bool"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("verifier"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("verifier"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("contract Verifier"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("verifierAddr"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("verifierAddr"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
            ]),
            events: ::core::convert::From::from([
                (
                    ::std::borrow::ToOwned::to_owned("DKIMRegistryUpdated"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "DKIMRegistryUpdated",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("dkimRegistry"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("EmailAuthed"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned("EmailAuthed"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("emailNullifier"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    indexed: true,
                                },
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("msgHash"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    indexed: true,
                                },
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("accountSalt"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    indexed: true,
                                },
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("isCodeExist"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    indexed: false,
                                },
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    indexed: false,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("Initialized"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned("Initialized"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("version"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(64usize),
                                    indexed: false,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("OwnershipTransferred"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "OwnershipTransferred",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("previousOwner"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    indexed: true,
                                },
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("newOwner"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("SubjectTemplateDeleted"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "SubjectTemplateDeleted",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("SubjectTemplateInserted"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "SubjectTemplateInserted",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("SubjectTemplateUpdated"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "SubjectTemplateUpdated",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("templateId"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("TimestampCheckEnabled"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned(
                                "TimestampCheckEnabled",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("enabled"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bool,
                                    indexed: false,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("Upgraded"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned("Upgraded"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("implementation"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("VerifierUpdated"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Event {
                            name: ::std::borrow::ToOwned::to_owned("VerifierUpdated"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::EventParam {
                                    name: ::std::borrow::ToOwned::to_owned("verifier"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    indexed: true,
                                },
                            ],
                            anonymous: false,
                        },
                    ],
                ),
            ]),
            errors: ::core::convert::From::from([
                (
                    ::std::borrow::ToOwned::to_owned("AddressEmptyCode"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned("AddressEmptyCode"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("target"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("ERC1967InvalidImplementation"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "ERC1967InvalidImplementation",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("implementation"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("ERC1967NonPayable"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned("ERC1967NonPayable"),
                            inputs: ::std::vec![],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("FailedInnerCall"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned("FailedInnerCall"),
                            inputs: ::std::vec![],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("InvalidInitialization"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "InvalidInitialization",
                            ),
                            inputs: ::std::vec![],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("NotInitializing"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned("NotInitializing"),
                            inputs: ::std::vec![],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("OwnableInvalidOwner"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "OwnableInvalidOwner",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("owner"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("OwnableUnauthorizedAccount"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "OwnableUnauthorizedAccount",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("account"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("UUPSUnauthorizedCallContext"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "UUPSUnauthorizedCallContext",
                            ),
                            inputs: ::std::vec![],
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("UUPSUnsupportedProxiableUUID"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::AbiError {
                            name: ::std::borrow::ToOwned::to_owned(
                                "UUPSUnsupportedProxiableUUID",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("slot"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::FixedBytes(
                                        32usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes32"),
                                    ),
                                },
                            ],
                        },
                    ],
                ),
            ]),
            receive: false,
            fallback: false,
        }
    }
    ///The parsed JSON ABI of the contract.
    pub static EMAILAUTH_ABI: ::ethers::contract::Lazy<::ethers::core::abi::Abi> = ::ethers::contract::Lazy::new(
        __abi,
    );
    #[rustfmt::skip]
    const __BYTECODE: &[u8] = b"`\xA0`@R0`\x80R4\x80\x15a\0\x14W`\0\x80\xFD[P`\x80Qa.\\a\0>`\09`\0\x81\x81a\x19\x14\x01R\x81\x81a\x19=\x01Ra\x1B^\x01Ra.\\`\0\xF3\xFE`\x80`@R`\x046\x10a\x01\xACW`\x005`\xE0\x1C\x80cR\xD1\x90-\x11a\0\xECW\x80c\xA5\0\x12\\\x11a\0\x8AW\x80c\xBE\x13\xF4|\x11a\0dW\x80c\xBE\x13\xF4|\x14a\x05\x85W\x80c\xC4\xB8M\xF4\x14a\x05\xA5W\x80c\xE4S\xC0\xF3\x14a\x05\xC5W\x80c\xF2\xFD\xE3\x8B\x14a\x05\xE5W`\0\x80\xFD[\x80c\xA5\0\x12\\\x14a\x04\xFCW\x80c\xAD<\xB1\xCC\x14a\x05\x1CW\x80c\xAD?_\x9B\x14a\x05eW`\0\x80\xFD[\x80cqP\x18\xA6\x11a\0\xC6W\x80cqP\x18\xA6\x14a\x04PW\x80c\x80X\x11\xEC\x14a\x04eW\x80c\x8D\xA5\xCB[\x14a\x04\x92W\x80c\x97\xFC\0|\x14a\x04\xDCW`\0\x80\xFD[\x80cR\xD1\x90-\x14a\x03\xFAW\x80cf>\xA2\xE2\x14a\x04\x0FW\x80clt\x92\x1E\x14a\x04:W`\0\x80\xFD[\x80c+\xDE\x03=\x11a\x01YW\x80cK\xD0w`\x11a\x013W\x80cK\xD0w`\x14a\x03xW\x80cM\xBB\x82\xF1\x14a\x03\xA5W\x80cO\x1E\xF2\x86\x14a\x03\xC7W\x80cQ\x9EP\xD1\x14a\x03\xDAW`\0\x80\xFD[\x80c+\xDE\x03=\x14a\x03\x11W\x80c>V\xF5)\x14a\x031W\x80c@\n\xD5\xCE\x14a\x03KW`\0\x80\xFD[\x80c\x1E\x05\xA0(\x11a\x01\x8AW\x80c\x1E\x05\xA0(\x14a\x02wW\x80c a7\xAA\x14a\x02\xA4W\x80c+z\xC3\xF3\x14a\x02\xE4W`\0\x80\xFD[\x80c\x16&\xBA~\x14a\x01\xB1W\x80c\x19\xD8\xACa\x14a\x02\x07W\x80c\x1B\xC0\x1B\x83\x14a\x02+W[`\0\x80\xFD[4\x80\x15a\x01\xBDW`\0\x80\xFD[Pa\x01\xD1a\x01\xCC6`\x04a#QV[a\x06\x05V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x81R` \x01[`@Q\x80\x91\x03\x90\xF3[4\x80\x15a\x02\x13W`\0\x80\xFD[Pa\x02\x1D`\x05T\x81V[`@Q\x90\x81R` \x01a\x01\xFEV[4\x80\x15a\x027W`\0\x80\xFD[P`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16\x81R` \x01a\x01\xFEV[4\x80\x15a\x02\x83W`\0\x80\xFD[Pa\x02\x97a\x02\x926`\x04a#\x98V[a\x06\x89V[`@Qa\x01\xFE\x91\x90a$\x1FV[4\x80\x15a\x02\xB0W`\0\x80\xFD[Pa\x02\xD4a\x02\xBF6`\x04a#\x98V[`\x06` R`\0\x90\x81R`@\x90 T`\xFF\x16\x81V[`@Q\x90\x15\x15\x81R` \x01a\x01\xFEV[4\x80\x15a\x02\xF0W`\0\x80\xFD[P`\x02Ta\x02R\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15a\x03\x1DW`\0\x80\xFD[Pa\x02\x1Da\x03,6`\x04a%iV[a\x07\xE6V[4\x80\x15a\x03=W`\0\x80\xFD[P`\x07Ta\x02\xD4\x90`\xFF\x16\x81V[4\x80\x15a\x03WW`\0\x80\xFD[P`\x01Ta\x02R\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15a\x03\x84W`\0\x80\xFD[Pa\x03\x98a\x03\x936`\x04a%\xCCV[a\x08\x1FV[`@Qa\x01\xFE\x91\x90a%\xEEV[4\x80\x15a\x03\xB1W`\0\x80\xFD[Pa\x03\xC5a\x03\xC06`\x04a&\x01V[a\x08\xD8V[\0[a\x03\xC5a\x03\xD56`\x04a&\xE2V[a\n\x0FV[4\x80\x15a\x03\xE6W`\0\x80\xFD[Pa\x03\xC5a\x03\xF56`\x04a#\x98V[a\n.V[4\x80\x15a\x04\x06W`\0\x80\xFD[Pa\x02\x1Da\n\xF0V[4\x80\x15a\x04\x1BW`\0\x80\xFD[P`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x02RV[4\x80\x15a\x04FW`\0\x80\xFD[Pa\x02\x1D`\0T\x81V[4\x80\x15a\x04\\W`\0\x80\xFD[Pa\x03\xC5a\x0B\x1FV[4\x80\x15a\x04qW`\0\x80\xFD[Pa\x02\x1Da\x04\x806`\x04a#\x98V[`\x04` R`\0\x90\x81R`@\x90 T\x81V[4\x80\x15a\x04\x9EW`\0\x80\xFD[P\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x02RV[4\x80\x15a\x04\xE8W`\0\x80\xFD[Pa\x03\xC5a\x04\xF76`\x04a'\x1AV[a\x0B3V[4\x80\x15a\x05\x08W`\0\x80\xFD[Pa\x03\xC5a\x05\x176`\x04a'\x1AV[a\x0C'V[4\x80\x15a\x05(W`\0\x80\xFD[Pa\x03\x98`@Q\x80`@\x01`@R\x80`\x05\x81R` \x01\x7F5.0.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81V[4\x80\x15a\x05qW`\0\x80\xFD[Pa\x02\x1Da\x05\x806`\x04a'5V[a\r\x1BV[4\x80\x15a\x05\x91W`\0\x80\xFD[Pa\x03\xC5a\x05\xA06`\x04a(\x8AV[a\x14\xBCV[4\x80\x15a\x05\xB1W`\0\x80\xFD[Pa\x03\xC5a\x05\xC06`\x04a&\x01V[a\x16mV[4\x80\x15a\x05\xD1W`\0\x80\xFD[Pa\x03\xC5a\x05\xE06`\x04a(\xB4V[a\x17\x9DV[4\x80\x15a\x05\xF1W`\0\x80\xFD[Pa\x03\xC5a\x06\x006`\x04a'\x1AV[a\x18\nV[`\0\x80\x82\x80` \x01\x90Q\x81\x01\x90a\x06\x1C\x91\x90a(\xD1V[`\0\x81\x81R`\x04` R`@\x90 T\x90\x91P\x84\x90\x03a\x06^WP\x7F\x16&\xBA~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90Pa\x06\x83V[P\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90P[\x92\x91PPV[`\0\x81\x81R`\x03` R`@\x90 T``\x90a\x07\x06W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01[`@Q\x80\x91\x03\x90\xFD[`\0\x82\x81R`\x03` \x90\x81R`@\x80\x83 \x80T\x82Q\x81\x85\x02\x81\x01\x85\x01\x90\x93R\x80\x83R\x91\x93\x90\x92\x84\x01[\x82\x82\x10\x15a\x07\xDBW\x83\x82\x90`\0R` `\0 \x01\x80Ta\x07N\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\x07z\x90a(\xEAV[\x80\x15a\x07\xC7W\x80`\x1F\x10a\x07\x9CWa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\x07\xC7V[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\x07\xAAW\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81R` \x01\x90`\x01\x01\x90a\x07/V[PPPP\x90P\x91\x90PV[`\0\x84\x84\x84\x84`@Q` \x01a\x07\xFF\x94\x93\x92\x91\x90a)=V[`@Q` \x81\x83\x03\x03\x81R\x90`@R\x80Q\x90` \x01 \x90P\x94\x93PPPPV[`\x03` R\x81`\0R`@`\0 \x81\x81T\x81\x10a\x08;W`\0\x80\xFD[\x90`\0R` `\0 \x01`\0\x91P\x91PP\x80Ta\x08W\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\x08\x83\x90a(\xEAV[\x80\x15a\x08\xD0W\x80`\x1F\x10a\x08\xA5Wa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\x08\xD0V[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\x08\xB3W\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81V[a\x08\xE0a\x18nV[`\0\x81Q\x11a\tKW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Fsubject template is empty\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` R`@\x90 Ta\t\xC0W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` \x90\x81R`@\x90\x91 \x82Qa\t\xDF\x92\x84\x01\x90a!\x13V[P`@Q\x82\x90\x7F8p?\xAA\x9B\xCB,a\xEC\x01\xD5\xC0\xB9\xBEg\x06f\x18\x0B\x17\x08w\xB2n\x0Bz\x16\xB6\x14E\x13\x13\x90`\0\x90\xA2PPV[a\n\x17a\x18\xFCV[a\n \x82a\x1A\0V[a\n*\x82\x82a\x1A\x08V[PPV[a\n6a\x18nV[`\0\x81\x81R`\x03` R`@\x90 Ta\n\xABW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x81\x81R`\x03` R`@\x81 a\n\xC2\x91a!iV[`@Q\x81\x90\x7F\xF3\xD7 \xEC\x91FJ\xE1\xC7i(%\x86\n\x9D?B\xD0X\xA6I=)e\xE2\xB8\xAE\x85\x86\x83\xEC\x1C\x90`\0\x90\xA2PV[`\0a\n\xFAa\x1BFV[P\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x90V[a\x0B'a\x18nV[a\x0B1`\0a\x1B\xB5V[V[a\x0B;a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x0B\xB8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Finvalid verifier address\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x81\x17\x90\x91U`@Q\x7F\xD2@\x15\xCC\x99\xCC\x17\0\xCA\xFC\xA3\x04(@\xA1\xD8\xAC\x1E9d\xFD.\x0E7\xEA)\xC6T\x05n\xE3'\x90`\0\x90\xA2PV[a\x0C/a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x0C\xACW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1D`$\x82\x01R\x7Finvalid dkim registry address\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x01\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x81\x17\x90\x91U`@Q\x7F}\xCBO!\xAA\x90q)?\xB8\xD2\x820mRi\xB1\x10\xFB}\xB1>\xBD@\x07\xD1\xCCR\xDFf\x98q\x90`\0\x90\xA2PV[`\0a\r%a\x18nV[\x81Q`\0\x90\x81R`\x03` \x90\x81R`@\x80\x83 \x80T\x82Q\x81\x85\x02\x81\x01\x85\x01\x90\x93R\x80\x83R\x91\x92\x90\x91\x90\x84\x90\x84\x01[\x82\x82\x10\x15a\r\xFFW\x83\x82\x90`\0R` `\0 \x01\x80Ta\rr\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\r\x9E\x90a(\xEAV[\x80\x15a\r\xEBW\x80`\x1F\x10a\r\xC0Wa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\r\xEBV[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\r\xCEW\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81R` \x01\x90`\x01\x01\x90a\rSV[PPPP\x90P`\0\x81Q\x11a\x0EpW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x01T``\x84\x01Q\x80Q` \x90\x91\x01Q`@Q\x7F\xE7\xA7\x97z\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x93\x16\x92c\xE7\xA7\x97z\x92a\x0E\xD3\x92\x90\x91`\x04\x01a)\xD7V[` `@Q\x80\x83\x03\x81\x86Z\xFA\x15\x80\x15a\x0E\xF0W=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90a\x0F\x14\x91\x90a)\xF9V[\x15\x15`\x01\x14a\x0F\x7FW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Finvalid dkim public key hash\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[``\x83\x01Q`\x80\x01Q`\0\x90\x81R`\x06` R`@\x90 T`\xFF\x16\x15a\x10\x01W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Femail nullifier already used\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[\x82``\x01Q`\xA0\x01Q`\0T\x14a\x10tW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Finvalid account salt\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x07T`\xFF\x16\x15\x80a\x10\x8CWP``\x83\x01Q`@\x01Q\x15[\x80a\x10\xA0WP`\x05T\x83``\x01Q`@\x01Q\x11[a\x11\x06W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x11`$\x82\x01R\x7Finvalid timestamp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[` \x83\x01Q`@Q\x7F)\x1C\xE0\xC1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0\x91s\x98\x1E=\xF9R5\x8AWu<{\x85\xDEyI\xDAJ\xBC\xF5J\x91c)\x1C\xE0\xC1\x91a\x11^\x91\x86\x90`\x04\x01a*\x16V[`\0`@Q\x80\x83\x03\x81\x86Z\xF4\x15\x80\x15a\x11{W=`\0\x80>=`\0\xFD[PPPP`@Q=`\0\x82>`\x1F=\x90\x81\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x82\x01`@Ra\x11\xC1\x91\x90\x81\x01\x90a+\nV[\x90P`\0a\x11\xDB\x85``\x01Q``\x01Q\x86`@\x01Qa\x1CKV[\x90Pa\x11\xE7\x82\x82a\x1D\xAEV[a\x12MW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0F`$\x82\x01R\x7Finvalid subject\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x02T``\x86\x01Q`@Q\x7F\x9E\xCD\x83\x10\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x92\x16\x91c\x9E\xCD\x83\x10\x91a\x12\xA6\x91`\x04\x01a+xV[` `@Q\x80\x83\x03\x81\x86Z\xFA\x15\x80\x15a\x12\xC3W=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90a\x12\xE7\x91\x90a)\xF9V[\x15\x15`\x01\x14a\x13RW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid email proof\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0a\x13x\x86``\x01Q`\xA0\x01Q\x87``\x01Q`\xC0\x01Q\x88`\0\x01Q\x89` \x01Qa\x07\xE6V[``\x87\x01Q`\x80\x01Q`\0\x90\x81R`\x04` R`@\x90 T\x90\x91P\x15a\x13\xFAW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Femail already authed\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[``\x86\x01\x80Q`\x80\x90\x81\x01Q`\0\x90\x81R`\x06` \x90\x81R`@\x80\x83 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90U\x84Q\x80\x82\x01Q`\x05U\x84\x01Q\x83R`\x04\x90\x91R\x90\x81\x90 \x84\x90U\x91Q`\xA0\x81\x01Q\x91\x81\x01Q`\xC0\x90\x91\x01Q\x89Q\x93Q\x92\x93\x85\x93\x7Fzn\x85\xED\xDD\x13\x82c[X^\xE5\xBA\xAF\xDF\x90\xFF\xE3\xF6\xDC%J\xB4r\x96~\xF5h\xCFo\xBD+\x92a\x14\xA9\x92\x90\x15\x15\x82R` \x82\x01R`@\x01\x90V[`@Q\x80\x91\x03\x90\xA4\x93PPPP[\x91\x90PV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0\x80Th\x01\0\0\0\0\0\0\0\0\x81\x04`\xFF\x16\x15\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x81\x15\x80\x15a\x15\x07WP\x82[\x90P`\0\x82g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\x01\x14\x80\x15a\x15$WP0;\x15[\x90P\x81\x15\x80\x15a\x152WP\x80\x15[\x15a\x15iW`@Q\x7F\xF9.\xE8\xA9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\x16`\x01\x17\x85U\x83\x15a\x15\xCAW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16h\x01\0\0\0\0\0\0\0\0\x17\x85U[a\x15\xD3\x87a\x1D\xD5V[`\0\x86\x90U`\x07\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90U\x83\x15a\x16dW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x85U`@Q`\x01\x81R\x7F\xC7\xF5\x05\xB2\xF3q\xAE!u\xEEI\x13\xF4I\x9E\x1F&3\xA7\xB5\x93c!\xEE\xD1\xCD\xAE\xB6\x11Q\x81\xD2\x90` \x01`@Q\x80\x91\x03\x90\xA1[PPPPPPPV[`\0\x81Q\x11a\x16\xD8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Fsubject template is empty\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` R`@\x90 T\x15a\x17NW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1A`$\x82\x01R\x7Ftemplate id already exists\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` \x90\x81R`@\x90\x91 \x82Qa\x17m\x92\x84\x01\x90a!\x13V[P`@Q\x82\x90\x7F9\xFD\x0C8\xA5d2\xFA\xEC\xDF\x1C9\xB4\xF5\xAFp\xDC\\\x9C\xB5\xFB<q\xD5\x1Da\xF7z\xBA\xD9u+\x90`\0\x90\xA2PPV[a\x17\xA5a\x18nV[`\x07\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16\x82\x15\x15\x90\x81\x17\x90\x91U`@Q\x90\x81R\x7Fe\xEE\x18.\x1D\xCAo\xAC\xD66\x9F\xE7|sb\r\xCE\xAAMiM\xD6\xF2\0\xCF\xA7\xB9\"(\xC4\x8E\xDD\x90` \x01`@Q\x80\x91\x03\x90\xA1PV[a\x18\x12a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x18bW`@Q\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0`\x04\x82\x01R`$\x01a\x06\xFDV[a\x18k\x81a\x1B\xB5V[PV[3a\x18\xAD\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14a\x0B1W`@Q\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R3`\x04\x82\x01R`$\x01a\x06\xFDV[0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x14\x80a\x19\xC9WP\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x19\xB0\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBCTs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14\x15[\x15a\x0B1W`@Q\x7F\xE0|\x8D\xBA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[a\x18ka\x18nV[\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16cR\xD1\x90-`@Q\x81c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01` `@Q\x80\x83\x03\x81\x86Z\xFA\x92PPP\x80\x15a\x1A\x8DWP`@\x80Q`\x1F=\x90\x81\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x82\x01\x90\x92Ra\x1A\x8A\x91\x81\x01\x90a(\xD1V[`\x01[a\x1A\xDBW`@Q\x7FL\x9C\x8C\xE3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16`\x04\x82\x01R`$\x01a\x06\xFDV[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x81\x14a\x1B7W`@Q\x7F\xAA\x1DI\xA4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x81\x01\x82\x90R`$\x01a\x06\xFDV[a\x1BA\x83\x83a\x1D\xE6V[PPPV[0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x14a\x0B1W`@Q\x7F\xE0|\x8D\xBA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x81\x16\x91\x82\x17\x84U`@Q\x92\x16\x91\x82\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90`\0\x90\xA3PPPV[``\x82Q\x82\x11\x15a\x1C\xB8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7FInvalid number of characters\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[\x82Q\x83\x90`\0\x90a\x1C\xCA\x90\x85\x90a,7V[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a\x1C\xE2Wa\x1C\xE2a!\xEAV[`@Q\x90\x80\x82R\x80`\x1F\x01`\x1F\x19\x16` \x01\x82\x01`@R\x80\x15a\x1D\x0CW` \x82\x01\x81\x806\x837\x01\x90P[P\x90P\x83[\x82Q\x81\x10\x15a\x1D\xA5W\x82\x81\x81Q\x81\x10a\x1D,Wa\x1D,a,qV[\x01` \x01Q\x7F\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x82a\x1D^\x87\x84a,7V[\x81Q\x81\x10a\x1DnWa\x1Dna,qV[` \x01\x01\x90~\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x19\x16\x90\x81`\0\x1A\x90SP`\x01\x01a\x1D\x11V[P\x94\x93PPPPV[`\0\x81Q\x83Q\x14\x80\x15a\x1D\xCEWP\x81\x80Q\x90` \x01 \x83\x80Q\x90` \x01 \x14[\x93\x92PPPV[a\x1D\xDDa\x1EIV[a\x18k\x81a\x1E\xB0V[a\x1D\xEF\x82a\x1E\xB8V[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x7F\xBC|\xD7Z \xEE'\xFD\x9A\xDE\xBA\xB3 A\xF7U!M\xBCk\xFF\xA9\x0C\xC0\"[9\xDA.\\-;\x90`\0\x90\xA2\x80Q\x15a\x1EAWa\x1BA\x82\x82a\x1F\x87V[a\n*a \nV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0Th\x01\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16a\x0B1W`@Q\x7F\xD7\xE6\xBC\xF8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[a\x18\x12a\x1EIV[\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16;`\0\x03a\x1F!W`@Q\x7FL\x9C\x8C\xE3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16`\x04\x82\x01R`$\x01a\x06\xFDV[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x92\x90\x92\x16\x91\x90\x91\x17\x90UV[```\0\x80\x84s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x84`@Qa\x1F\xB1\x91\x90a,\xA0V[`\0`@Q\x80\x83\x03\x81\x85Z\xF4\x91PP=\x80`\0\x81\x14a\x1F\xECW`@Q\x91P`\x1F\x19`?=\x01\x16\x82\x01`@R=\x82R=`\0` \x84\x01>a\x1F\xF1V[``\x91P[P\x91P\x91Pa \x01\x85\x83\x83a BV[\x95\x94PPPPPV[4\x15a\x0B1W`@Q\x7F\xB3\x98\x97\x9F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[``\x82a WWa R\x82a \xD1V[a\x1D\xCEV[\x81Q\x15\x80\x15a {WPs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16;\x15[\x15a \xCAW`@Q\x7F\x99\x96\xB3\x15\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\x04\x82\x01R`$\x01a\x06\xFDV[P\x92\x91PPV[\x80Q\x15a \xE1W\x80Q\x80\x82` \x01\xFD[`@Q\x7F\x14%\xEAB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x82\x80T\x82\x82U\x90`\0R` `\0 \x90\x81\x01\x92\x82\x15a!YW\x91` \x02\x82\x01[\x82\x81\x11\x15a!YW\x82Q\x82\x90a!I\x90\x82a-\x0CV[P\x91` \x01\x91\x90`\x01\x01\x90a!3V[Pa!e\x92\x91Pa!\x83V[P\x90V[P\x80T`\0\x82U\x90`\0R` `\0 \x90\x81\x01\x90a\x18k\x91\x90[\x80\x82\x11\x15a!eW`\0a!\x97\x82\x82a!\xA0V[P`\x01\x01a!\x83V[P\x80Ta!\xAC\x90a(\xEAV[`\0\x82U\x80`\x1F\x10a!\xBCWPPV[`\x1F\x01` \x90\x04\x90`\0R` `\0 \x90\x81\x01\x90a\x18k\x91\x90[\x80\x82\x11\x15a!eW`\0\x81U`\x01\x01a!\xD6V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`A`\x04R`$`\0\xFD[`@Q`\x80\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"<Wa\"<a!\xEAV[`@R\x90V[`@Qa\x01\0\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"<Wa\"<a!\xEAV[`@Q`\x1F\x82\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"\xADWa\"\xADa!\xEAV[`@R\x91\x90PV[`\0g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x15a\"\xCFWa\"\xCFa!\xEAV[P`\x1F\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16` \x01\x90V[`\0\x82`\x1F\x83\x01\x12a#\x0CW`\0\x80\xFD[\x815a#\x1Fa#\x1A\x82a\"\xB5V[a\"fV[\x81\x81R\x84` \x83\x86\x01\x01\x11\x15a#4W`\0\x80\xFD[\x81` \x85\x01` \x83\x017`\0\x91\x81\x01` \x01\x91\x90\x91R\x93\x92PPPV[`\0\x80`@\x83\x85\x03\x12\x15a#dW`\0\x80\xFD[\x825\x91P` \x83\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a#\x82W`\0\x80\xFD[a#\x8E\x85\x82\x86\x01a\"\xFBV[\x91PP\x92P\x92\x90PV[`\0` \x82\x84\x03\x12\x15a#\xAAW`\0\x80\xFD[P5\x91\x90PV[`\0[\x83\x81\x10\x15a#\xCCW\x81\x81\x01Q\x83\x82\x01R` \x01a#\xB4V[PP`\0\x91\x01RV[`\0\x81Q\x80\x84Ra#\xED\x81` \x86\x01` \x86\x01a#\xB1V[`\x1F\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x92\x90\x92\x01` \x01\x92\x91PPV[`\0` \x80\x83\x01` \x84R\x80\x85Q\x80\x83R`@\x86\x01\x91P`@\x81`\x05\x1B\x87\x01\x01\x92P` \x87\x01`\0[\x82\x81\x10\x15a$\x94W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC0\x88\x86\x03\x01\x84Ra$\x82\x85\x83Qa#\xD5V[\x94P\x92\x85\x01\x92\x90\x85\x01\x90`\x01\x01a$HV[P\x92\x97\x96PPPPPPPV[\x80\x15\x15\x81\x14a\x18kW`\0\x80\xFD[\x805a\x14\xB7\x81a$\xA1V[`\0g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x15a$\xD4Wa$\xD4a!\xEAV[P`\x05\x1B` \x01\x90V[`\0\x82`\x1F\x83\x01\x12a$\xEFW`\0\x80\xFD[\x815` a$\xFFa#\x1A\x83a$\xBAV[\x82\x81R`\x05\x92\x90\x92\x1B\x84\x01\x81\x01\x91\x81\x81\x01\x90\x86\x84\x11\x15a%\x1EW`\0\x80\xFD[\x82\x86\x01[\x84\x81\x10\x15a%^W\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a%BW`\0\x80\x81\xFD[a%P\x89\x86\x83\x8B\x01\x01a\"\xFBV[\x84RP\x91\x83\x01\x91\x83\x01a%\"V[P\x96\x95PPPPPPV[`\0\x80`\0\x80`\x80\x85\x87\x03\x12\x15a%\x7FW`\0\x80\xFD[\x845\x93P` \x85\x015a%\x91\x81a$\xA1V[\x92P`@\x85\x015\x91P``\x85\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a%\xB4W`\0\x80\xFD[a%\xC0\x87\x82\x88\x01a$\xDEV[\x91PP\x92\x95\x91\x94P\x92PV[`\0\x80`@\x83\x85\x03\x12\x15a%\xDFW`\0\x80\xFD[PP\x805\x92` \x90\x91\x015\x91PV[` \x81R`\0a\x1D\xCE` \x83\x01\x84a#\xD5V[`\0\x80`@\x83\x85\x03\x12\x15a&\x14W`\0\x80\xFD[\x825\x91P` \x80\x84\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15a&4W`\0\x80\xFD[\x81\x86\x01\x91P\x86`\x1F\x83\x01\x12a&HW`\0\x80\xFD[\x815a&Va#\x1A\x82a$\xBAV[\x81\x81R`\x05\x91\x90\x91\x1B\x83\x01\x84\x01\x90\x84\x81\x01\x90\x89\x83\x11\x15a&uW`\0\x80\xFD[\x85\x85\x01[\x83\x81\x10\x15a&\xADW\x805\x85\x81\x11\x15a&\x91W`\0\x80\x81\xFD[a&\x9F\x8C\x89\x83\x8A\x01\x01a\"\xFBV[\x84RP\x91\x86\x01\x91\x86\x01a&yV[P\x80\x96PPPPPPP\x92P\x92\x90PV[\x805s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x14a\x14\xB7W`\0\x80\xFD[`\0\x80`@\x83\x85\x03\x12\x15a&\xF5W`\0\x80\xFD[a&\xFE\x83a&\xBEV[\x91P` \x83\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a#\x82W`\0\x80\xFD[`\0` \x82\x84\x03\x12\x15a',W`\0\x80\xFD[a\x1D\xCE\x82a&\xBEV[`\0` \x82\x84\x03\x12\x15a'GW`\0\x80\xFD[\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15a'_W`\0\x80\xFD[\x90\x83\x01\x90`\x80\x82\x86\x03\x12\x15a'sW`\0\x80\xFD[a'{a\"\x19V[\x825\x81R` \x83\x015\x82\x81\x11\x15a'\x91W`\0\x80\xFD[a'\x9D\x87\x82\x86\x01a$\xDEV[` \x83\x01RP`@\x83\x015`@\x82\x01R``\x83\x015\x82\x81\x11\x15a'\xBFW`\0\x80\xFD[\x92\x90\x92\x01\x91a\x01\0\x83\x87\x03\x12\x15a'\xD5W`\0\x80\xFD[a'\xDDa\"BV[\x835\x83\x81\x11\x15a'\xECW`\0\x80\xFD[a'\xF8\x88\x82\x87\x01a\"\xFBV[\x82RP` \x84\x015` \x82\x01R`@\x84\x015`@\x82\x01R``\x84\x015\x83\x81\x11\x15a(!W`\0\x80\xFD[a(-\x88\x82\x87\x01a\"\xFBV[``\x83\x01RP`\x80\x84\x015`\x80\x82\x01R`\xA0\x84\x015`\xA0\x82\x01Ra(S`\xC0\x85\x01a$\xAFV[`\xC0\x82\x01R`\xE0\x84\x015\x83\x81\x11\x15a(jW`\0\x80\xFD[a(v\x88\x82\x87\x01a\"\xFBV[`\xE0\x83\x01RP``\x82\x01R\x95\x94PPPPPV[`\0\x80`@\x83\x85\x03\x12\x15a(\x9DW`\0\x80\xFD[a(\xA6\x83a&\xBEV[\x94` \x93\x90\x93\x015\x93PPPV[`\0` \x82\x84\x03\x12\x15a(\xC6W`\0\x80\xFD[\x815a\x1D\xCE\x81a$\xA1V[`\0` \x82\x84\x03\x12\x15a(\xE3W`\0\x80\xFD[PQ\x91\x90PV[`\x01\x81\x81\x1C\x90\x82\x16\x80a(\xFEW`\x7F\x82\x16\x91P[` \x82\x10\x81\x03a)7W\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\"`\x04R`$`\0\xFD[P\x91\x90PV[`\0`\x80\x82\x01\x86\x83R` \x86\x15\x15` \x85\x01R\x85`@\x85\x01R`\x80``\x85\x01R\x81\x85Q\x80\x84R`\xA0\x86\x01\x91P`\xA0\x81`\x05\x1B\x87\x01\x01\x93P` \x87\x01`\0[\x82\x81\x10\x15a)\xC7W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x88\x87\x03\x01\x84Ra)\xB5\x86\x83Qa#\xD5V[\x95P\x92\x84\x01\x92\x90\x84\x01\x90`\x01\x01a){V[P\x93\x9A\x99PPPPPPPPPPV[`@\x81R`\0a)\xEA`@\x83\x01\x85a#\xD5V[\x90P\x82` \x83\x01R\x93\x92PPPV[`\0` \x82\x84\x03\x12\x15a*\x0BW`\0\x80\xFD[\x81Qa\x1D\xCE\x81a$\xA1V[`\0`@\x82\x01`@\x83R\x80\x85Q\x80\x83R``\x85\x01\x91P``\x81`\x05\x1B\x86\x01\x01\x92P` \x80\x88\x01`\0[\x83\x81\x10\x15a*\x8BW\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0\x88\x87\x03\x01\x85Ra*y\x86\x83Qa#\xD5V[\x95P\x93\x82\x01\x93\x90\x82\x01\x90`\x01\x01a*?V[PP\x85\x84\x03\x81\x87\x01R\x86Q\x80\x85R\x81\x85\x01\x93P\x91P`\x05\x82\x90\x1B\x84\x01\x81\x01\x87\x82\x01`\0[\x84\x81\x10\x15a*\xFBW\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x87\x84\x03\x01\x86Ra*\xE9\x83\x83Qa#\xD5V[\x95\x84\x01\x95\x92P\x90\x83\x01\x90`\x01\x01a*\xAFV[P\x90\x99\x98PPPPPPPPPV[`\0` \x82\x84\x03\x12\x15a+\x1CW`\0\x80\xFD[\x81Qg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a+3W`\0\x80\xFD[\x82\x01`\x1F\x81\x01\x84\x13a+DW`\0\x80\xFD[\x80Qa+Ra#\x1A\x82a\"\xB5V[\x81\x81R\x85` \x83\x85\x01\x01\x11\x15a+gW`\0\x80\xFD[a \x01\x82` \x83\x01` \x86\x01a#\xB1V[` \x81R`\0\x82Qa\x01\0\x80` \x85\x01Ra+\x97a\x01 \x85\x01\x83a#\xD5V[\x91P` \x85\x01Q`@\x85\x01R`@\x85\x01Q``\x85\x01R``\x85\x01Q\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x80\x86\x85\x03\x01`\x80\x87\x01Ra+\xE7\x84\x83a#\xD5V[\x93P`\x80\x87\x01Q`\xA0\x87\x01R`\xA0\x87\x01Q`\xC0\x87\x01R`\xC0\x87\x01Q\x91Pa,\x12`\xE0\x87\x01\x83\x15\x15\x90RV[`\xE0\x87\x01Q\x91P\x80\x86\x85\x03\x01\x83\x87\x01RPa,-\x83\x82a#\xD5V[\x96\x95PPPPPPV[\x81\x81\x03\x81\x81\x11\x15a\x06\x83W\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\x11`\x04R`$`\0\xFD[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`2`\x04R`$`\0\xFD[`\0\x82Qa,\xB2\x81\x84` \x87\x01a#\xB1V[\x91\x90\x91\x01\x92\x91PPV[`\x1F\x82\x11\x15a\x1BAW`\0\x81`\0R` `\0 `\x1F\x85\x01`\x05\x1C\x81\x01` \x86\x10\x15a,\xE5WP\x80[`\x1F\x85\x01`\x05\x1C\x82\x01\x91P[\x81\x81\x10\x15a-\x04W\x82\x81U`\x01\x01a,\xF1V[PPPPPPV[\x81Qg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a-&Wa-&a!\xEAV[a-:\x81a-4\x84Ta(\xEAV[\x84a,\xBCV[` \x80`\x1F\x83\x11`\x01\x81\x14a-\x8DW`\0\x84\x15a-WWP\x85\x83\x01Q[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x03\x86\x90\x1B\x1C\x19\x16`\x01\x85\x90\x1B\x17\x85Ua-\x04V[`\0\x85\x81R` \x81 \x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x86\x16\x91[\x82\x81\x10\x15a-\xDAW\x88\x86\x01Q\x82U\x94\x84\x01\x94`\x01\x90\x91\x01\x90\x84\x01a-\xBBV[P\x85\x82\x10\x15a.\x16W\x87\x85\x01Q\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x03\x88\x90\x1B`\xF8\x16\x1C\x19\x16\x81U[PPPPP`\x01\x90\x81\x1B\x01\x90UPV\xFE\xA2dipfsX\"\x12 WP`782\xF1\xB5\x8D\xA4\x06\xD3\xDB2\x94q\n\xAE-\ri\xCB\x8E\x0F\xA3\xA2\xF0B\x83\xCE\xE6HdsolcC\0\x08\x17\x003";
    /// The bytecode of the contract.
    pub static EMAILAUTH_BYTECODE: ::ethers::core::types::Bytes = ::ethers::core::types::Bytes::from_static(
        __BYTECODE,
    );
    #[rustfmt::skip]
    const __DEPLOYED_BYTECODE: &[u8] = b"`\x80`@R`\x046\x10a\x01\xACW`\x005`\xE0\x1C\x80cR\xD1\x90-\x11a\0\xECW\x80c\xA5\0\x12\\\x11a\0\x8AW\x80c\xBE\x13\xF4|\x11a\0dW\x80c\xBE\x13\xF4|\x14a\x05\x85W\x80c\xC4\xB8M\xF4\x14a\x05\xA5W\x80c\xE4S\xC0\xF3\x14a\x05\xC5W\x80c\xF2\xFD\xE3\x8B\x14a\x05\xE5W`\0\x80\xFD[\x80c\xA5\0\x12\\\x14a\x04\xFCW\x80c\xAD<\xB1\xCC\x14a\x05\x1CW\x80c\xAD?_\x9B\x14a\x05eW`\0\x80\xFD[\x80cqP\x18\xA6\x11a\0\xC6W\x80cqP\x18\xA6\x14a\x04PW\x80c\x80X\x11\xEC\x14a\x04eW\x80c\x8D\xA5\xCB[\x14a\x04\x92W\x80c\x97\xFC\0|\x14a\x04\xDCW`\0\x80\xFD[\x80cR\xD1\x90-\x14a\x03\xFAW\x80cf>\xA2\xE2\x14a\x04\x0FW\x80clt\x92\x1E\x14a\x04:W`\0\x80\xFD[\x80c+\xDE\x03=\x11a\x01YW\x80cK\xD0w`\x11a\x013W\x80cK\xD0w`\x14a\x03xW\x80cM\xBB\x82\xF1\x14a\x03\xA5W\x80cO\x1E\xF2\x86\x14a\x03\xC7W\x80cQ\x9EP\xD1\x14a\x03\xDAW`\0\x80\xFD[\x80c+\xDE\x03=\x14a\x03\x11W\x80c>V\xF5)\x14a\x031W\x80c@\n\xD5\xCE\x14a\x03KW`\0\x80\xFD[\x80c\x1E\x05\xA0(\x11a\x01\x8AW\x80c\x1E\x05\xA0(\x14a\x02wW\x80c a7\xAA\x14a\x02\xA4W\x80c+z\xC3\xF3\x14a\x02\xE4W`\0\x80\xFD[\x80c\x16&\xBA~\x14a\x01\xB1W\x80c\x19\xD8\xACa\x14a\x02\x07W\x80c\x1B\xC0\x1B\x83\x14a\x02+W[`\0\x80\xFD[4\x80\x15a\x01\xBDW`\0\x80\xFD[Pa\x01\xD1a\x01\xCC6`\x04a#QV[a\x06\x05V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x81R` \x01[`@Q\x80\x91\x03\x90\xF3[4\x80\x15a\x02\x13W`\0\x80\xFD[Pa\x02\x1D`\x05T\x81V[`@Q\x90\x81R` \x01a\x01\xFEV[4\x80\x15a\x027W`\0\x80\xFD[P`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16\x81R` \x01a\x01\xFEV[4\x80\x15a\x02\x83W`\0\x80\xFD[Pa\x02\x97a\x02\x926`\x04a#\x98V[a\x06\x89V[`@Qa\x01\xFE\x91\x90a$\x1FV[4\x80\x15a\x02\xB0W`\0\x80\xFD[Pa\x02\xD4a\x02\xBF6`\x04a#\x98V[`\x06` R`\0\x90\x81R`@\x90 T`\xFF\x16\x81V[`@Q\x90\x15\x15\x81R` \x01a\x01\xFEV[4\x80\x15a\x02\xF0W`\0\x80\xFD[P`\x02Ta\x02R\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15a\x03\x1DW`\0\x80\xFD[Pa\x02\x1Da\x03,6`\x04a%iV[a\x07\xE6V[4\x80\x15a\x03=W`\0\x80\xFD[P`\x07Ta\x02\xD4\x90`\xFF\x16\x81V[4\x80\x15a\x03WW`\0\x80\xFD[P`\x01Ta\x02R\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15a\x03\x84W`\0\x80\xFD[Pa\x03\x98a\x03\x936`\x04a%\xCCV[a\x08\x1FV[`@Qa\x01\xFE\x91\x90a%\xEEV[4\x80\x15a\x03\xB1W`\0\x80\xFD[Pa\x03\xC5a\x03\xC06`\x04a&\x01V[a\x08\xD8V[\0[a\x03\xC5a\x03\xD56`\x04a&\xE2V[a\n\x0FV[4\x80\x15a\x03\xE6W`\0\x80\xFD[Pa\x03\xC5a\x03\xF56`\x04a#\x98V[a\n.V[4\x80\x15a\x04\x06W`\0\x80\xFD[Pa\x02\x1Da\n\xF0V[4\x80\x15a\x04\x1BW`\0\x80\xFD[P`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x02RV[4\x80\x15a\x04FW`\0\x80\xFD[Pa\x02\x1D`\0T\x81V[4\x80\x15a\x04\\W`\0\x80\xFD[Pa\x03\xC5a\x0B\x1FV[4\x80\x15a\x04qW`\0\x80\xFD[Pa\x02\x1Da\x04\x806`\x04a#\x98V[`\x04` R`\0\x90\x81R`@\x90 T\x81V[4\x80\x15a\x04\x9EW`\0\x80\xFD[P\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x02RV[4\x80\x15a\x04\xE8W`\0\x80\xFD[Pa\x03\xC5a\x04\xF76`\x04a'\x1AV[a\x0B3V[4\x80\x15a\x05\x08W`\0\x80\xFD[Pa\x03\xC5a\x05\x176`\x04a'\x1AV[a\x0C'V[4\x80\x15a\x05(W`\0\x80\xFD[Pa\x03\x98`@Q\x80`@\x01`@R\x80`\x05\x81R` \x01\x7F5.0.0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81V[4\x80\x15a\x05qW`\0\x80\xFD[Pa\x02\x1Da\x05\x806`\x04a'5V[a\r\x1BV[4\x80\x15a\x05\x91W`\0\x80\xFD[Pa\x03\xC5a\x05\xA06`\x04a(\x8AV[a\x14\xBCV[4\x80\x15a\x05\xB1W`\0\x80\xFD[Pa\x03\xC5a\x05\xC06`\x04a&\x01V[a\x16mV[4\x80\x15a\x05\xD1W`\0\x80\xFD[Pa\x03\xC5a\x05\xE06`\x04a(\xB4V[a\x17\x9DV[4\x80\x15a\x05\xF1W`\0\x80\xFD[Pa\x03\xC5a\x06\x006`\x04a'\x1AV[a\x18\nV[`\0\x80\x82\x80` \x01\x90Q\x81\x01\x90a\x06\x1C\x91\x90a(\xD1V[`\0\x81\x81R`\x04` R`@\x90 T\x90\x91P\x84\x90\x03a\x06^WP\x7F\x16&\xBA~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90Pa\x06\x83V[P\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90P[\x92\x91PPV[`\0\x81\x81R`\x03` R`@\x90 T``\x90a\x07\x06W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01[`@Q\x80\x91\x03\x90\xFD[`\0\x82\x81R`\x03` \x90\x81R`@\x80\x83 \x80T\x82Q\x81\x85\x02\x81\x01\x85\x01\x90\x93R\x80\x83R\x91\x93\x90\x92\x84\x01[\x82\x82\x10\x15a\x07\xDBW\x83\x82\x90`\0R` `\0 \x01\x80Ta\x07N\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\x07z\x90a(\xEAV[\x80\x15a\x07\xC7W\x80`\x1F\x10a\x07\x9CWa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\x07\xC7V[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\x07\xAAW\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81R` \x01\x90`\x01\x01\x90a\x07/V[PPPP\x90P\x91\x90PV[`\0\x84\x84\x84\x84`@Q` \x01a\x07\xFF\x94\x93\x92\x91\x90a)=V[`@Q` \x81\x83\x03\x03\x81R\x90`@R\x80Q\x90` \x01 \x90P\x94\x93PPPPV[`\x03` R\x81`\0R`@`\0 \x81\x81T\x81\x10a\x08;W`\0\x80\xFD[\x90`\0R` `\0 \x01`\0\x91P\x91PP\x80Ta\x08W\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\x08\x83\x90a(\xEAV[\x80\x15a\x08\xD0W\x80`\x1F\x10a\x08\xA5Wa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\x08\xD0V[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\x08\xB3W\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81V[a\x08\xE0a\x18nV[`\0\x81Q\x11a\tKW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Fsubject template is empty\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` R`@\x90 Ta\t\xC0W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` \x90\x81R`@\x90\x91 \x82Qa\t\xDF\x92\x84\x01\x90a!\x13V[P`@Q\x82\x90\x7F8p?\xAA\x9B\xCB,a\xEC\x01\xD5\xC0\xB9\xBEg\x06f\x18\x0B\x17\x08w\xB2n\x0Bz\x16\xB6\x14E\x13\x13\x90`\0\x90\xA2PPV[a\n\x17a\x18\xFCV[a\n \x82a\x1A\0V[a\n*\x82\x82a\x1A\x08V[PPV[a\n6a\x18nV[`\0\x81\x81R`\x03` R`@\x90 Ta\n\xABW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x81\x81R`\x03` R`@\x81 a\n\xC2\x91a!iV[`@Q\x81\x90\x7F\xF3\xD7 \xEC\x91FJ\xE1\xC7i(%\x86\n\x9D?B\xD0X\xA6I=)e\xE2\xB8\xAE\x85\x86\x83\xEC\x1C\x90`\0\x90\xA2PV[`\0a\n\xFAa\x1BFV[P\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x90V[a\x0B'a\x18nV[a\x0B1`\0a\x1B\xB5V[V[a\x0B;a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x0B\xB8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Finvalid verifier address\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x81\x17\x90\x91U`@Q\x7F\xD2@\x15\xCC\x99\xCC\x17\0\xCA\xFC\xA3\x04(@\xA1\xD8\xAC\x1E9d\xFD.\x0E7\xEA)\xC6T\x05n\xE3'\x90`\0\x90\xA2PV[a\x0C/a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x0C\xACW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1D`$\x82\x01R\x7Finvalid dkim registry address\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x01\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x81\x17\x90\x91U`@Q\x7F}\xCBO!\xAA\x90q)?\xB8\xD2\x820mRi\xB1\x10\xFB}\xB1>\xBD@\x07\xD1\xCCR\xDFf\x98q\x90`\0\x90\xA2PV[`\0a\r%a\x18nV[\x81Q`\0\x90\x81R`\x03` \x90\x81R`@\x80\x83 \x80T\x82Q\x81\x85\x02\x81\x01\x85\x01\x90\x93R\x80\x83R\x91\x92\x90\x91\x90\x84\x90\x84\x01[\x82\x82\x10\x15a\r\xFFW\x83\x82\x90`\0R` `\0 \x01\x80Ta\rr\x90a(\xEAV[\x80`\x1F\x01` \x80\x91\x04\x02` \x01`@Q\x90\x81\x01`@R\x80\x92\x91\x90\x81\x81R` \x01\x82\x80Ta\r\x9E\x90a(\xEAV[\x80\x15a\r\xEBW\x80`\x1F\x10a\r\xC0Wa\x01\0\x80\x83T\x04\x02\x83R\x91` \x01\x91a\r\xEBV[\x82\x01\x91\x90`\0R` `\0 \x90[\x81T\x81R\x90`\x01\x01\x90` \x01\x80\x83\x11a\r\xCEW\x82\x90\x03`\x1F\x16\x82\x01\x91[PPPPP\x81R` \x01\x90`\x01\x01\x90a\rSV[PPPP\x90P`\0\x81Q\x11a\x0EpW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Ftemplate id not exists\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x01T``\x84\x01Q\x80Q` \x90\x91\x01Q`@Q\x7F\xE7\xA7\x97z\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x93\x16\x92c\xE7\xA7\x97z\x92a\x0E\xD3\x92\x90\x91`\x04\x01a)\xD7V[` `@Q\x80\x83\x03\x81\x86Z\xFA\x15\x80\x15a\x0E\xF0W=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90a\x0F\x14\x91\x90a)\xF9V[\x15\x15`\x01\x14a\x0F\x7FW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Finvalid dkim public key hash\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[``\x83\x01Q`\x80\x01Q`\0\x90\x81R`\x06` R`@\x90 T`\xFF\x16\x15a\x10\x01W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Femail nullifier already used\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[\x82``\x01Q`\xA0\x01Q`\0T\x14a\x10tW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Finvalid account salt\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x07T`\xFF\x16\x15\x80a\x10\x8CWP``\x83\x01Q`@\x01Q\x15[\x80a\x10\xA0WP`\x05T\x83``\x01Q`@\x01Q\x11[a\x11\x06W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x11`$\x82\x01R\x7Finvalid timestamp\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[` \x83\x01Q`@Q\x7F)\x1C\xE0\xC1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0\x91s\x98\x1E=\xF9R5\x8AWu<{\x85\xDEyI\xDAJ\xBC\xF5J\x91c)\x1C\xE0\xC1\x91a\x11^\x91\x86\x90`\x04\x01a*\x16V[`\0`@Q\x80\x83\x03\x81\x86Z\xF4\x15\x80\x15a\x11{W=`\0\x80>=`\0\xFD[PPPP`@Q=`\0\x82>`\x1F=\x90\x81\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x82\x01`@Ra\x11\xC1\x91\x90\x81\x01\x90a+\nV[\x90P`\0a\x11\xDB\x85``\x01Q``\x01Q\x86`@\x01Qa\x1CKV[\x90Pa\x11\xE7\x82\x82a\x1D\xAEV[a\x12MW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x0F`$\x82\x01R\x7Finvalid subject\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\x02T``\x86\x01Q`@Q\x7F\x9E\xCD\x83\x10\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x92\x16\x91c\x9E\xCD\x83\x10\x91a\x12\xA6\x91`\x04\x01a+xV[` `@Q\x80\x83\x03\x81\x86Z\xFA\x15\x80\x15a\x12\xC3W=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90a\x12\xE7\x91\x90a)\xF9V[\x15\x15`\x01\x14a\x13RW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid email proof\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0a\x13x\x86``\x01Q`\xA0\x01Q\x87``\x01Q`\xC0\x01Q\x88`\0\x01Q\x89` \x01Qa\x07\xE6V[``\x87\x01Q`\x80\x01Q`\0\x90\x81R`\x04` R`@\x90 T\x90\x91P\x15a\x13\xFAW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Femail already authed\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[``\x86\x01\x80Q`\x80\x90\x81\x01Q`\0\x90\x81R`\x06` \x90\x81R`@\x80\x83 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90U\x84Q\x80\x82\x01Q`\x05U\x84\x01Q\x83R`\x04\x90\x91R\x90\x81\x90 \x84\x90U\x91Q`\xA0\x81\x01Q\x91\x81\x01Q`\xC0\x90\x91\x01Q\x89Q\x93Q\x92\x93\x85\x93\x7Fzn\x85\xED\xDD\x13\x82c[X^\xE5\xBA\xAF\xDF\x90\xFF\xE3\xF6\xDC%J\xB4r\x96~\xF5h\xCFo\xBD+\x92a\x14\xA9\x92\x90\x15\x15\x82R` \x82\x01R`@\x01\x90V[`@Q\x80\x91\x03\x90\xA4\x93PPPP[\x91\x90PV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0\x80Th\x01\0\0\0\0\0\0\0\0\x81\x04`\xFF\x16\x15\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x81\x15\x80\x15a\x15\x07WP\x82[\x90P`\0\x82g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\x01\x14\x80\x15a\x15$WP0;\x15[\x90P\x81\x15\x80\x15a\x152WP\x80\x15[\x15a\x15iW`@Q\x7F\xF9.\xE8\xA9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\x16`\x01\x17\x85U\x83\x15a\x15\xCAW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16h\x01\0\0\0\0\0\0\0\0\x17\x85U[a\x15\xD3\x87a\x1D\xD5V[`\0\x86\x90U`\x07\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90U\x83\x15a\x16dW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x85U`@Q`\x01\x81R\x7F\xC7\xF5\x05\xB2\xF3q\xAE!u\xEEI\x13\xF4I\x9E\x1F&3\xA7\xB5\x93c!\xEE\xD1\xCD\xAE\xB6\x11Q\x81\xD2\x90` \x01`@Q\x80\x91\x03\x90\xA1[PPPPPPPV[`\0\x81Q\x11a\x16\xD8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Fsubject template is empty\0\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` R`@\x90 T\x15a\x17NW`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1A`$\x82\x01R\x7Ftemplate id already exists\0\0\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[`\0\x82\x81R`\x03` \x90\x81R`@\x90\x91 \x82Qa\x17m\x92\x84\x01\x90a!\x13V[P`@Q\x82\x90\x7F9\xFD\x0C8\xA5d2\xFA\xEC\xDF\x1C9\xB4\xF5\xAFp\xDC\\\x9C\xB5\xFB<q\xD5\x1Da\xF7z\xBA\xD9u+\x90`\0\x90\xA2PPV[a\x17\xA5a\x18nV[`\x07\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16\x82\x15\x15\x90\x81\x17\x90\x91U`@Q\x90\x81R\x7Fe\xEE\x18.\x1D\xCAo\xAC\xD66\x9F\xE7|sb\r\xCE\xAAMiM\xD6\xF2\0\xCF\xA7\xB9\"(\xC4\x8E\xDD\x90` \x01`@Q\x80\x91\x03\x90\xA1PV[a\x18\x12a\x18nV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16a\x18bW`@Q\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0`\x04\x82\x01R`$\x01a\x06\xFDV[a\x18k\x81a\x1B\xB5V[PV[3a\x18\xAD\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14a\x0B1W`@Q\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R3`\x04\x82\x01R`$\x01a\x06\xFDV[0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x14\x80a\x19\xC9WP\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16a\x19\xB0\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBCTs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14\x15[\x15a\x0B1W`@Q\x7F\xE0|\x8D\xBA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[a\x18ka\x18nV[\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16cR\xD1\x90-`@Q\x81c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01` `@Q\x80\x83\x03\x81\x86Z\xFA\x92PPP\x80\x15a\x1A\x8DWP`@\x80Q`\x1F=\x90\x81\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x82\x01\x90\x92Ra\x1A\x8A\x91\x81\x01\x90a(\xD1V[`\x01[a\x1A\xDBW`@Q\x7FL\x9C\x8C\xE3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16`\x04\x82\x01R`$\x01a\x06\xFDV[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x81\x14a\x1B7W`@Q\x7F\xAA\x1DI\xA4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x81\x01\x82\x90R`$\x01a\x06\xFDV[a\x1BA\x83\x83a\x1D\xE6V[PPPV[0s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x7F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x14a\x0B1W`@Q\x7F\xE0|\x8D\xBA\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x81\x16\x91\x82\x17\x84U`@Q\x92\x16\x91\x82\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90`\0\x90\xA3PPPV[``\x82Q\x82\x11\x15a\x1C\xB8W`@Q\x7F\x08\xC3y\xA0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7FInvalid number of characters\0\0\0\0`D\x82\x01R`d\x01a\x06\xFDV[\x82Q\x83\x90`\0\x90a\x1C\xCA\x90\x85\x90a,7V[g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a\x1C\xE2Wa\x1C\xE2a!\xEAV[`@Q\x90\x80\x82R\x80`\x1F\x01`\x1F\x19\x16` \x01\x82\x01`@R\x80\x15a\x1D\x0CW` \x82\x01\x81\x806\x837\x01\x90P[P\x90P\x83[\x82Q\x81\x10\x15a\x1D\xA5W\x82\x81\x81Q\x81\x10a\x1D,Wa\x1D,a,qV[\x01` \x01Q\x7F\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x82a\x1D^\x87\x84a,7V[\x81Q\x81\x10a\x1DnWa\x1Dna,qV[` \x01\x01\x90~\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x19\x16\x90\x81`\0\x1A\x90SP`\x01\x01a\x1D\x11V[P\x94\x93PPPPV[`\0\x81Q\x83Q\x14\x80\x15a\x1D\xCEWP\x81\x80Q\x90` \x01 \x83\x80Q\x90` \x01 \x14[\x93\x92PPPV[a\x1D\xDDa\x1EIV[a\x18k\x81a\x1E\xB0V[a\x1D\xEF\x82a\x1E\xB8V[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x7F\xBC|\xD7Z \xEE'\xFD\x9A\xDE\xBA\xB3 A\xF7U!M\xBCk\xFF\xA9\x0C\xC0\"[9\xDA.\\-;\x90`\0\x90\xA2\x80Q\x15a\x1EAWa\x1BA\x82\x82a\x1F\x87V[a\n*a \nV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0Th\x01\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16a\x0B1W`@Q\x7F\xD7\xE6\xBC\xF8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[a\x18\x12a\x1EIV[\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16;`\0\x03a\x1F!W`@Q\x7FL\x9C\x8C\xE3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16`\x04\x82\x01R`$\x01a\x06\xFDV[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x92\x90\x92\x16\x91\x90\x91\x17\x90UV[```\0\x80\x84s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x84`@Qa\x1F\xB1\x91\x90a,\xA0V[`\0`@Q\x80\x83\x03\x81\x85Z\xF4\x91PP=\x80`\0\x81\x14a\x1F\xECW`@Q\x91P`\x1F\x19`?=\x01\x16\x82\x01`@R=\x82R=`\0` \x84\x01>a\x1F\xF1V[``\x91P[P\x91P\x91Pa \x01\x85\x83\x83a BV[\x95\x94PPPPPV[4\x15a\x0B1W`@Q\x7F\xB3\x98\x97\x9F\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[``\x82a WWa R\x82a \xD1V[a\x1D\xCEV[\x81Q\x15\x80\x15a {WPs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16;\x15[\x15a \xCAW`@Q\x7F\x99\x96\xB3\x15\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\x04\x82\x01R`$\x01a\x06\xFDV[P\x92\x91PPV[\x80Q\x15a \xE1W\x80Q\x80\x82` \x01\xFD[`@Q\x7F\x14%\xEAB\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x82\x80T\x82\x82U\x90`\0R` `\0 \x90\x81\x01\x92\x82\x15a!YW\x91` \x02\x82\x01[\x82\x81\x11\x15a!YW\x82Q\x82\x90a!I\x90\x82a-\x0CV[P\x91` \x01\x91\x90`\x01\x01\x90a!3V[Pa!e\x92\x91Pa!\x83V[P\x90V[P\x80T`\0\x82U\x90`\0R` `\0 \x90\x81\x01\x90a\x18k\x91\x90[\x80\x82\x11\x15a!eW`\0a!\x97\x82\x82a!\xA0V[P`\x01\x01a!\x83V[P\x80Ta!\xAC\x90a(\xEAV[`\0\x82U\x80`\x1F\x10a!\xBCWPPV[`\x1F\x01` \x90\x04\x90`\0R` `\0 \x90\x81\x01\x90a\x18k\x91\x90[\x80\x82\x11\x15a!eW`\0\x81U`\x01\x01a!\xD6V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`A`\x04R`$`\0\xFD[`@Q`\x80\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"<Wa\"<a!\xEAV[`@R\x90V[`@Qa\x01\0\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"<Wa\"<a!\xEAV[`@Q`\x1F\x82\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15a\"\xADWa\"\xADa!\xEAV[`@R\x91\x90PV[`\0g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x15a\"\xCFWa\"\xCFa!\xEAV[P`\x1F\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16` \x01\x90V[`\0\x82`\x1F\x83\x01\x12a#\x0CW`\0\x80\xFD[\x815a#\x1Fa#\x1A\x82a\"\xB5V[a\"fV[\x81\x81R\x84` \x83\x86\x01\x01\x11\x15a#4W`\0\x80\xFD[\x81` \x85\x01` \x83\x017`\0\x91\x81\x01` \x01\x91\x90\x91R\x93\x92PPPV[`\0\x80`@\x83\x85\x03\x12\x15a#dW`\0\x80\xFD[\x825\x91P` \x83\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a#\x82W`\0\x80\xFD[a#\x8E\x85\x82\x86\x01a\"\xFBV[\x91PP\x92P\x92\x90PV[`\0` \x82\x84\x03\x12\x15a#\xAAW`\0\x80\xFD[P5\x91\x90PV[`\0[\x83\x81\x10\x15a#\xCCW\x81\x81\x01Q\x83\x82\x01R` \x01a#\xB4V[PP`\0\x91\x01RV[`\0\x81Q\x80\x84Ra#\xED\x81` \x86\x01` \x86\x01a#\xB1V[`\x1F\x01\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x16\x92\x90\x92\x01` \x01\x92\x91PPV[`\0` \x80\x83\x01` \x84R\x80\x85Q\x80\x83R`@\x86\x01\x91P`@\x81`\x05\x1B\x87\x01\x01\x92P` \x87\x01`\0[\x82\x81\x10\x15a$\x94W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC0\x88\x86\x03\x01\x84Ra$\x82\x85\x83Qa#\xD5V[\x94P\x92\x85\x01\x92\x90\x85\x01\x90`\x01\x01a$HV[P\x92\x97\x96PPPPPPPV[\x80\x15\x15\x81\x14a\x18kW`\0\x80\xFD[\x805a\x14\xB7\x81a$\xA1V[`\0g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x11\x15a$\xD4Wa$\xD4a!\xEAV[P`\x05\x1B` \x01\x90V[`\0\x82`\x1F\x83\x01\x12a$\xEFW`\0\x80\xFD[\x815` a$\xFFa#\x1A\x83a$\xBAV[\x82\x81R`\x05\x92\x90\x92\x1B\x84\x01\x81\x01\x91\x81\x81\x01\x90\x86\x84\x11\x15a%\x1EW`\0\x80\xFD[\x82\x86\x01[\x84\x81\x10\x15a%^W\x805g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a%BW`\0\x80\x81\xFD[a%P\x89\x86\x83\x8B\x01\x01a\"\xFBV[\x84RP\x91\x83\x01\x91\x83\x01a%\"V[P\x96\x95PPPPPPV[`\0\x80`\0\x80`\x80\x85\x87\x03\x12\x15a%\x7FW`\0\x80\xFD[\x845\x93P` \x85\x015a%\x91\x81a$\xA1V[\x92P`@\x85\x015\x91P``\x85\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a%\xB4W`\0\x80\xFD[a%\xC0\x87\x82\x88\x01a$\xDEV[\x91PP\x92\x95\x91\x94P\x92PV[`\0\x80`@\x83\x85\x03\x12\x15a%\xDFW`\0\x80\xFD[PP\x805\x92` \x90\x91\x015\x91PV[` \x81R`\0a\x1D\xCE` \x83\x01\x84a#\xD5V[`\0\x80`@\x83\x85\x03\x12\x15a&\x14W`\0\x80\xFD[\x825\x91P` \x80\x84\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15a&4W`\0\x80\xFD[\x81\x86\x01\x91P\x86`\x1F\x83\x01\x12a&HW`\0\x80\xFD[\x815a&Va#\x1A\x82a$\xBAV[\x81\x81R`\x05\x91\x90\x91\x1B\x83\x01\x84\x01\x90\x84\x81\x01\x90\x89\x83\x11\x15a&uW`\0\x80\xFD[\x85\x85\x01[\x83\x81\x10\x15a&\xADW\x805\x85\x81\x11\x15a&\x91W`\0\x80\x81\xFD[a&\x9F\x8C\x89\x83\x8A\x01\x01a\"\xFBV[\x84RP\x91\x86\x01\x91\x86\x01a&yV[P\x80\x96PPPPPPP\x92P\x92\x90PV[\x805s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x14a\x14\xB7W`\0\x80\xFD[`\0\x80`@\x83\x85\x03\x12\x15a&\xF5W`\0\x80\xFD[a&\xFE\x83a&\xBEV[\x91P` \x83\x015g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a#\x82W`\0\x80\xFD[`\0` \x82\x84\x03\x12\x15a',W`\0\x80\xFD[a\x1D\xCE\x82a&\xBEV[`\0` \x82\x84\x03\x12\x15a'GW`\0\x80\xFD[\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15a'_W`\0\x80\xFD[\x90\x83\x01\x90`\x80\x82\x86\x03\x12\x15a'sW`\0\x80\xFD[a'{a\"\x19V[\x825\x81R` \x83\x015\x82\x81\x11\x15a'\x91W`\0\x80\xFD[a'\x9D\x87\x82\x86\x01a$\xDEV[` \x83\x01RP`@\x83\x015`@\x82\x01R``\x83\x015\x82\x81\x11\x15a'\xBFW`\0\x80\xFD[\x92\x90\x92\x01\x91a\x01\0\x83\x87\x03\x12\x15a'\xD5W`\0\x80\xFD[a'\xDDa\"BV[\x835\x83\x81\x11\x15a'\xECW`\0\x80\xFD[a'\xF8\x88\x82\x87\x01a\"\xFBV[\x82RP` \x84\x015` \x82\x01R`@\x84\x015`@\x82\x01R``\x84\x015\x83\x81\x11\x15a(!W`\0\x80\xFD[a(-\x88\x82\x87\x01a\"\xFBV[``\x83\x01RP`\x80\x84\x015`\x80\x82\x01R`\xA0\x84\x015`\xA0\x82\x01Ra(S`\xC0\x85\x01a$\xAFV[`\xC0\x82\x01R`\xE0\x84\x015\x83\x81\x11\x15a(jW`\0\x80\xFD[a(v\x88\x82\x87\x01a\"\xFBV[`\xE0\x83\x01RP``\x82\x01R\x95\x94PPPPPV[`\0\x80`@\x83\x85\x03\x12\x15a(\x9DW`\0\x80\xFD[a(\xA6\x83a&\xBEV[\x94` \x93\x90\x93\x015\x93PPPV[`\0` \x82\x84\x03\x12\x15a(\xC6W`\0\x80\xFD[\x815a\x1D\xCE\x81a$\xA1V[`\0` \x82\x84\x03\x12\x15a(\xE3W`\0\x80\xFD[PQ\x91\x90PV[`\x01\x81\x81\x1C\x90\x82\x16\x80a(\xFEW`\x7F\x82\x16\x91P[` \x82\x10\x81\x03a)7W\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\"`\x04R`$`\0\xFD[P\x91\x90PV[`\0`\x80\x82\x01\x86\x83R` \x86\x15\x15` \x85\x01R\x85`@\x85\x01R`\x80``\x85\x01R\x81\x85Q\x80\x84R`\xA0\x86\x01\x91P`\xA0\x81`\x05\x1B\x87\x01\x01\x93P` \x87\x01`\0[\x82\x81\x10\x15a)\xC7W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x88\x87\x03\x01\x84Ra)\xB5\x86\x83Qa#\xD5V[\x95P\x92\x84\x01\x92\x90\x84\x01\x90`\x01\x01a){V[P\x93\x9A\x99PPPPPPPPPPV[`@\x81R`\0a)\xEA`@\x83\x01\x85a#\xD5V[\x90P\x82` \x83\x01R\x93\x92PPPV[`\0` \x82\x84\x03\x12\x15a*\x0BW`\0\x80\xFD[\x81Qa\x1D\xCE\x81a$\xA1V[`\0`@\x82\x01`@\x83R\x80\x85Q\x80\x83R``\x85\x01\x91P``\x81`\x05\x1B\x86\x01\x01\x92P` \x80\x88\x01`\0[\x83\x81\x10\x15a*\x8BW\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xA0\x88\x87\x03\x01\x85Ra*y\x86\x83Qa#\xD5V[\x95P\x93\x82\x01\x93\x90\x82\x01\x90`\x01\x01a*?V[PP\x85\x84\x03\x81\x87\x01R\x86Q\x80\x85R\x81\x85\x01\x93P\x91P`\x05\x82\x90\x1B\x84\x01\x81\x01\x87\x82\x01`\0[\x84\x81\x10\x15a*\xFBW\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x87\x84\x03\x01\x86Ra*\xE9\x83\x83Qa#\xD5V[\x95\x84\x01\x95\x92P\x90\x83\x01\x90`\x01\x01a*\xAFV[P\x90\x99\x98PPPPPPPPPV[`\0` \x82\x84\x03\x12\x15a+\x1CW`\0\x80\xFD[\x81Qg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a+3W`\0\x80\xFD[\x82\x01`\x1F\x81\x01\x84\x13a+DW`\0\x80\xFD[\x80Qa+Ra#\x1A\x82a\"\xB5V[\x81\x81R\x85` \x83\x85\x01\x01\x11\x15a+gW`\0\x80\xFD[a \x01\x82` \x83\x01` \x86\x01a#\xB1V[` \x81R`\0\x82Qa\x01\0\x80` \x85\x01Ra+\x97a\x01 \x85\x01\x83a#\xD5V[\x91P` \x85\x01Q`@\x85\x01R`@\x85\x01Q``\x85\x01R``\x85\x01Q\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x80\x86\x85\x03\x01`\x80\x87\x01Ra+\xE7\x84\x83a#\xD5V[\x93P`\x80\x87\x01Q`\xA0\x87\x01R`\xA0\x87\x01Q`\xC0\x87\x01R`\xC0\x87\x01Q\x91Pa,\x12`\xE0\x87\x01\x83\x15\x15\x90RV[`\xE0\x87\x01Q\x91P\x80\x86\x85\x03\x01\x83\x87\x01RPa,-\x83\x82a#\xD5V[\x96\x95PPPPPPV[\x81\x81\x03\x81\x81\x11\x15a\x06\x83W\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\x11`\x04R`$`\0\xFD[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`2`\x04R`$`\0\xFD[`\0\x82Qa,\xB2\x81\x84` \x87\x01a#\xB1V[\x91\x90\x91\x01\x92\x91PPV[`\x1F\x82\x11\x15a\x1BAW`\0\x81`\0R` `\0 `\x1F\x85\x01`\x05\x1C\x81\x01` \x86\x10\x15a,\xE5WP\x80[`\x1F\x85\x01`\x05\x1C\x82\x01\x91P[\x81\x81\x10\x15a-\x04W\x82\x81U`\x01\x01a,\xF1V[PPPPPPV[\x81Qg\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15a-&Wa-&a!\xEAV[a-:\x81a-4\x84Ta(\xEAV[\x84a,\xBCV[` \x80`\x1F\x83\x11`\x01\x81\x14a-\x8DW`\0\x84\x15a-WWP\x85\x83\x01Q[\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x03\x86\x90\x1B\x1C\x19\x16`\x01\x85\x90\x1B\x17\x85Ua-\x04V[`\0\x85\x81R` \x81 \x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE0\x86\x16\x91[\x82\x81\x10\x15a-\xDAW\x88\x86\x01Q\x82U\x94\x84\x01\x94`\x01\x90\x91\x01\x90\x84\x01a-\xBBV[P\x85\x82\x10\x15a.\x16W\x87\x85\x01Q\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF`\x03\x88\x90\x1B`\xF8\x16\x1C\x19\x16\x81U[PPPPP`\x01\x90\x81\x1B\x01\x90UPV\xFE\xA2dipfsX\"\x12 WP`782\xF1\xB5\x8D\xA4\x06\xD3\xDB2\x94q\n\xAE-\ri\xCB\x8E\x0F\xA3\xA2\xF0B\x83\xCE\xE6HdsolcC\0\x08\x17\x003";
    /// The deployed bytecode of the contract.
    pub static EMAILAUTH_DEPLOYED_BYTECODE: ::ethers::core::types::Bytes = ::ethers::core::types::Bytes::from_static(
        __DEPLOYED_BYTECODE,
    );
    pub struct EmailAuth<M>(::ethers::contract::Contract<M>);
    impl<M> ::core::clone::Clone for EmailAuth<M> {
        fn clone(&self) -> Self {
            Self(::core::clone::Clone::clone(&self.0))
        }
    }
    impl<M> ::core::ops::Deref for EmailAuth<M> {
        type Target = ::ethers::contract::Contract<M>;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }
    impl<M> ::core::ops::DerefMut for EmailAuth<M> {
        fn deref_mut(&mut self) -> &mut Self::Target {
            &mut self.0
        }
    }
    impl<M> ::core::fmt::Debug for EmailAuth<M> {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple(::core::stringify!(EmailAuth)).field(&self.address()).finish()
        }
    }
    impl<M: ::ethers::providers::Middleware> EmailAuth<M> {
        /// Creates a new contract instance with the specified `ethers` client at
        /// `address`. The contract derefs to a `ethers::Contract` object.
        pub fn new<T: Into<::ethers::core::types::Address>>(
            address: T,
            client: ::std::sync::Arc<M>,
        ) -> Self {
            Self(
                ::ethers::contract::Contract::new(
                    address.into(),
                    EMAILAUTH_ABI.clone(),
                    client,
                ),
            )
        }
        /// Constructs the general purpose `Deployer` instance based on the provided constructor arguments and sends it.
        /// Returns a new instance of a deployer that returns an instance of this contract after sending the transaction
        ///
        /// Notes:
        /// - If there are no constructor arguments, you should pass `()` as the argument.
        /// - The default poll duration is 7 seconds.
        /// - The default number of confirmations is 1 block.
        ///
        ///
        /// # Example
        ///
        /// Generate contract bindings with `abigen!` and deploy a new contract instance.
        ///
        /// *Note*: this requires a `bytecode` and `abi` object in the `greeter.json` artifact.
        ///
        /// ```ignore
        /// # async fn deploy<M: ethers::providers::Middleware>(client: ::std::sync::Arc<M>) {
        ///     abigen!(Greeter, "../greeter.json");
        ///
        ///    let greeter_contract = Greeter::deploy(client, "Hello world!".to_string()).unwrap().send().await.unwrap();
        ///    let msg = greeter_contract.greet().call().await.unwrap();
        /// # }
        /// ```
        pub fn deploy<T: ::ethers::core::abi::Tokenize>(
            client: ::std::sync::Arc<M>,
            constructor_args: T,
        ) -> ::core::result::Result<
            ::ethers::contract::builders::ContractDeployer<M, Self>,
            ::ethers::contract::ContractError<M>,
        > {
            let factory = ::ethers::contract::ContractFactory::new(
                EMAILAUTH_ABI.clone(),
                EMAILAUTH_BYTECODE.clone().into(),
                client,
            );
            let deployer = factory.deploy(constructor_args)?;
            let deployer = ::ethers::contract::ContractDeployer::new(deployer);
            Ok(deployer)
        }
        ///Calls the contract's `UPGRADE_INTERFACE_VERSION` (0xad3cb1cc) function
        pub fn upgrade_interface_version(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ::std::string::String> {
            self.0
                .method_hash([173, 60, 177, 204], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `accountSalt` (0x6c74921e) function
        pub fn account_salt(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 32]> {
            self.0
                .method_hash([108, 116, 146, 30], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `authEmail` (0xad3f5f9b) function
        pub fn auth_email(
            &self,
            email_auth_msg: EmailAuthMsg,
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 32]> {
            self.0
                .method_hash([173, 63, 95, 155], (email_auth_msg,))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `authedHash` (0x805811ec) function
        pub fn authed_hash(
            &self,
            p0: [u8; 32],
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 32]> {
            self.0
                .method_hash([128, 88, 17, 236], p0)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `computeMsgHash` (0x2bde033d) function
        pub fn compute_msg_hash(
            &self,
            account_salt: [u8; 32],
            is_code_exist: bool,
            template_id: ::ethers::core::types::U256,
            subject_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 32]> {
            self.0
                .method_hash(
                    [43, 222, 3, 61],
                    (account_salt, is_code_exist, template_id, subject_params),
                )
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `deleteSubjectTemplate` (0x519e50d1) function
        pub fn delete_subject_template(
            &self,
            template_id: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([81, 158, 80, 209], template_id)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `dkim` (0x400ad5ce) function
        pub fn dkim(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([64, 10, 213, 206], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `dkimRegistryAddr` (0x1bc01b83) function
        pub fn dkim_registry_addr(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([27, 192, 27, 131], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `getSubjectTemplate` (0x1e05a028) function
        pub fn get_subject_template(
            &self,
            template_id: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::std::vec::Vec<::std::string::String>,
        > {
            self.0
                .method_hash([30, 5, 160, 40], template_id)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `initialize` (0xbe13f47c) function
        pub fn initialize(
            &self,
            initial_owner: ::ethers::core::types::Address,
            account_salt: [u8; 32],
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([190, 19, 244, 124], (initial_owner, account_salt))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `insertSubjectTemplate` (0xc4b84df4) function
        pub fn insert_subject_template(
            &self,
            template_id: ::ethers::core::types::U256,
            subject_template: ::std::vec::Vec<::std::string::String>,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([196, 184, 77, 244], (template_id, subject_template))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `isValidSignature` (0x1626ba7e) function
        pub fn is_valid_signature(
            &self,
            hash: [u8; 32],
            signature: ::ethers::core::types::Bytes,
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 4]> {
            self.0
                .method_hash([22, 38, 186, 126], (hash, signature))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `lastTimestamp` (0x19d8ac61) function
        pub fn last_timestamp(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ::ethers::core::types::U256> {
            self.0
                .method_hash([25, 216, 172, 97], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `owner` (0x8da5cb5b) function
        pub fn owner(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([141, 165, 203, 91], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `proxiableUUID` (0x52d1902d) function
        pub fn proxiable_uuid(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, [u8; 32]> {
            self.0
                .method_hash([82, 209, 144, 45], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `renounceOwnership` (0x715018a6) function
        pub fn renounce_ownership(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([113, 80, 24, 166], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `setTimestampCheckEnabled` (0xe453c0f3) function
        pub fn set_timestamp_check_enabled(
            &self,
            enabled: bool,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([228, 83, 192, 243], enabled)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `subjectTemplates` (0x4bd07760) function
        pub fn subject_templates(
            &self,
            p0: ::ethers::core::types::U256,
            p1: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ::std::string::String> {
            self.0
                .method_hash([75, 208, 119, 96], (p0, p1))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `timestampCheckEnabled` (0x3e56f529) function
        pub fn timestamp_check_enabled(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, bool> {
            self.0
                .method_hash([62, 86, 245, 41], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `transferOwnership` (0xf2fde38b) function
        pub fn transfer_ownership(
            &self,
            new_owner: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([242, 253, 227, 139], new_owner)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `updateDKIMRegistry` (0xa500125c) function
        pub fn update_dkim_registry(
            &self,
            dkim_registry_addr: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([165, 0, 18, 92], dkim_registry_addr)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `updateSubjectTemplate` (0x4dbb82f1) function
        pub fn update_subject_template(
            &self,
            template_id: ::ethers::core::types::U256,
            subject_template: ::std::vec::Vec<::std::string::String>,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([77, 187, 130, 241], (template_id, subject_template))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `updateVerifier` (0x97fc007c) function
        pub fn update_verifier(
            &self,
            verifier_addr: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([151, 252, 0, 124], verifier_addr)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `upgradeToAndCall` (0x4f1ef286) function
        pub fn upgrade_to_and_call(
            &self,
            new_implementation: ::ethers::core::types::Address,
            data: ::ethers::core::types::Bytes,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([79, 30, 242, 134], (new_implementation, data))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `usedNullifiers` (0x206137aa) function
        pub fn used_nullifiers(
            &self,
            p0: [u8; 32],
        ) -> ::ethers::contract::builders::ContractCall<M, bool> {
            self.0
                .method_hash([32, 97, 55, 170], p0)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `verifier` (0x2b7ac3f3) function
        pub fn verifier(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([43, 122, 195, 243], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `verifierAddr` (0x663ea2e2) function
        pub fn verifier_addr(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([102, 62, 162, 226], ())
                .expect("method not found (this should never happen)")
        }
        ///Gets the contract's `DKIMRegistryUpdated` event
        pub fn dkim_registry_updated_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            DkimregistryUpdatedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `EmailAuthed` event
        pub fn email_authed_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            EmailAuthedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `Initialized` event
        pub fn initialized_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            InitializedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `OwnershipTransferred` event
        pub fn ownership_transferred_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            OwnershipTransferredFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `SubjectTemplateDeleted` event
        pub fn subject_template_deleted_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            SubjectTemplateDeletedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `SubjectTemplateInserted` event
        pub fn subject_template_inserted_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            SubjectTemplateInsertedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `SubjectTemplateUpdated` event
        pub fn subject_template_updated_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            SubjectTemplateUpdatedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `TimestampCheckEnabled` event
        pub fn timestamp_check_enabled_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            TimestampCheckEnabledFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `Upgraded` event
        pub fn upgraded_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            UpgradedFilter,
        > {
            self.0.event()
        }
        ///Gets the contract's `VerifierUpdated` event
        pub fn verifier_updated_filter(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            VerifierUpdatedFilter,
        > {
            self.0.event()
        }
        /// Returns an `Event` builder for all the events of this contract.
        pub fn events(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            EmailAuthEvents,
        > {
            self.0.event_with_filter(::core::default::Default::default())
        }
    }
    impl<M: ::ethers::providers::Middleware> From<::ethers::contract::Contract<M>>
    for EmailAuth<M> {
        fn from(contract: ::ethers::contract::Contract<M>) -> Self {
            Self::new(contract.address(), contract.client())
        }
    }
    ///Custom Error type `AddressEmptyCode` with signature `AddressEmptyCode(address)` and selector `0x9996b315`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "AddressEmptyCode", abi = "AddressEmptyCode(address)")]
    pub struct AddressEmptyCode {
        pub target: ::ethers::core::types::Address,
    }
    ///Custom Error type `ERC1967InvalidImplementation` with signature `ERC1967InvalidImplementation(address)` and selector `0x4c9c8ce3`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(
        name = "ERC1967InvalidImplementation",
        abi = "ERC1967InvalidImplementation(address)"
    )]
    pub struct ERC1967InvalidImplementation {
        pub implementation: ::ethers::core::types::Address,
    }
    ///Custom Error type `ERC1967NonPayable` with signature `ERC1967NonPayable()` and selector `0xb398979f`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "ERC1967NonPayable", abi = "ERC1967NonPayable()")]
    pub struct ERC1967NonPayable;
    ///Custom Error type `FailedInnerCall` with signature `FailedInnerCall()` and selector `0x1425ea42`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "FailedInnerCall", abi = "FailedInnerCall()")]
    pub struct FailedInnerCall;
    ///Custom Error type `InvalidInitialization` with signature `InvalidInitialization()` and selector `0xf92ee8a9`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "InvalidInitialization", abi = "InvalidInitialization()")]
    pub struct InvalidInitialization;
    ///Custom Error type `NotInitializing` with signature `NotInitializing()` and selector `0xd7e6bcf8`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "NotInitializing", abi = "NotInitializing()")]
    pub struct NotInitializing;
    ///Custom Error type `OwnableInvalidOwner` with signature `OwnableInvalidOwner(address)` and selector `0x1e4fbdf7`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(name = "OwnableInvalidOwner", abi = "OwnableInvalidOwner(address)")]
    pub struct OwnableInvalidOwner {
        pub owner: ::ethers::core::types::Address,
    }
    ///Custom Error type `OwnableUnauthorizedAccount` with signature `OwnableUnauthorizedAccount(address)` and selector `0x118cdaa7`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(
        name = "OwnableUnauthorizedAccount",
        abi = "OwnableUnauthorizedAccount(address)"
    )]
    pub struct OwnableUnauthorizedAccount {
        pub account: ::ethers::core::types::Address,
    }
    ///Custom Error type `UUPSUnauthorizedCallContext` with signature `UUPSUnauthorizedCallContext()` and selector `0xe07c8dba`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(
        name = "UUPSUnauthorizedCallContext",
        abi = "UUPSUnauthorizedCallContext()"
    )]
    pub struct UUPSUnauthorizedCallContext;
    ///Custom Error type `UUPSUnsupportedProxiableUUID` with signature `UUPSUnsupportedProxiableUUID(bytes32)` and selector `0xaa1d49a4`
    #[derive(
        Clone,
        ::ethers::contract::EthError,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[etherror(
        name = "UUPSUnsupportedProxiableUUID",
        abi = "UUPSUnsupportedProxiableUUID(bytes32)"
    )]
    pub struct UUPSUnsupportedProxiableUUID {
        pub slot: [u8; 32],
    }
    ///Container type for all of the contract's custom errors
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum EmailAuthErrors {
        AddressEmptyCode(AddressEmptyCode),
        ERC1967InvalidImplementation(ERC1967InvalidImplementation),
        ERC1967NonPayable(ERC1967NonPayable),
        FailedInnerCall(FailedInnerCall),
        InvalidInitialization(InvalidInitialization),
        NotInitializing(NotInitializing),
        OwnableInvalidOwner(OwnableInvalidOwner),
        OwnableUnauthorizedAccount(OwnableUnauthorizedAccount),
        UUPSUnauthorizedCallContext(UUPSUnauthorizedCallContext),
        UUPSUnsupportedProxiableUUID(UUPSUnsupportedProxiableUUID),
        /// The standard solidity revert string, with selector
        /// Error(string) -- 0x08c379a0
        RevertString(::std::string::String),
    }
    impl ::ethers::core::abi::AbiDecode for EmailAuthErrors {
        fn decode(
            data: impl AsRef<[u8]>,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::AbiError> {
            let data = data.as_ref();
            if let Ok(decoded) = <::std::string::String as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RevertString(decoded));
            }
            if let Ok(decoded) = <AddressEmptyCode as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AddressEmptyCode(decoded));
            }
            if let Ok(decoded) = <ERC1967InvalidImplementation as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ERC1967InvalidImplementation(decoded));
            }
            if let Ok(decoded) = <ERC1967NonPayable as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ERC1967NonPayable(decoded));
            }
            if let Ok(decoded) = <FailedInnerCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::FailedInnerCall(decoded));
            }
            if let Ok(decoded) = <InvalidInitialization as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::InvalidInitialization(decoded));
            }
            if let Ok(decoded) = <NotInitializing as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::NotInitializing(decoded));
            }
            if let Ok(decoded) = <OwnableInvalidOwner as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::OwnableInvalidOwner(decoded));
            }
            if let Ok(decoded) = <OwnableUnauthorizedAccount as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::OwnableUnauthorizedAccount(decoded));
            }
            if let Ok(decoded) = <UUPSUnauthorizedCallContext as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UUPSUnauthorizedCallContext(decoded));
            }
            if let Ok(decoded) = <UUPSUnsupportedProxiableUUID as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UUPSUnsupportedProxiableUUID(decoded));
            }
            Err(::ethers::core::abi::Error::InvalidData.into())
        }
    }
    impl ::ethers::core::abi::AbiEncode for EmailAuthErrors {
        fn encode(self) -> ::std::vec::Vec<u8> {
            match self {
                Self::AddressEmptyCode(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ERC1967InvalidImplementation(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ERC1967NonPayable(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::FailedInnerCall(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::InvalidInitialization(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::NotInitializing(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::OwnableInvalidOwner(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::OwnableUnauthorizedAccount(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UUPSUnauthorizedCallContext(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UUPSUnsupportedProxiableUUID(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RevertString(s) => ::ethers::core::abi::AbiEncode::encode(s),
            }
        }
    }
    impl ::ethers::contract::ContractRevert for EmailAuthErrors {
        fn valid_selector(selector: [u8; 4]) -> bool {
            match selector {
                [0x08, 0xc3, 0x79, 0xa0] => true,
                _ if selector
                    == <AddressEmptyCode as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <ERC1967InvalidImplementation as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <ERC1967NonPayable as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <FailedInnerCall as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <InvalidInitialization as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <NotInitializing as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <OwnableInvalidOwner as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <OwnableUnauthorizedAccount as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <UUPSUnauthorizedCallContext as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ if selector
                    == <UUPSUnsupportedProxiableUUID as ::ethers::contract::EthError>::selector() => {
                    true
                }
                _ => false,
            }
        }
    }
    impl ::core::fmt::Display for EmailAuthErrors {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::AddressEmptyCode(element) => ::core::fmt::Display::fmt(element, f),
                Self::ERC1967InvalidImplementation(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::ERC1967NonPayable(element) => ::core::fmt::Display::fmt(element, f),
                Self::FailedInnerCall(element) => ::core::fmt::Display::fmt(element, f),
                Self::InvalidInitialization(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::NotInitializing(element) => ::core::fmt::Display::fmt(element, f),
                Self::OwnableInvalidOwner(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::OwnableUnauthorizedAccount(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::UUPSUnauthorizedCallContext(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::UUPSUnsupportedProxiableUUID(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::RevertString(s) => ::core::fmt::Display::fmt(s, f),
            }
        }
    }
    impl ::core::convert::From<::std::string::String> for EmailAuthErrors {
        fn from(value: String) -> Self {
            Self::RevertString(value)
        }
    }
    impl ::core::convert::From<AddressEmptyCode> for EmailAuthErrors {
        fn from(value: AddressEmptyCode) -> Self {
            Self::AddressEmptyCode(value)
        }
    }
    impl ::core::convert::From<ERC1967InvalidImplementation> for EmailAuthErrors {
        fn from(value: ERC1967InvalidImplementation) -> Self {
            Self::ERC1967InvalidImplementation(value)
        }
    }
    impl ::core::convert::From<ERC1967NonPayable> for EmailAuthErrors {
        fn from(value: ERC1967NonPayable) -> Self {
            Self::ERC1967NonPayable(value)
        }
    }
    impl ::core::convert::From<FailedInnerCall> for EmailAuthErrors {
        fn from(value: FailedInnerCall) -> Self {
            Self::FailedInnerCall(value)
        }
    }
    impl ::core::convert::From<InvalidInitialization> for EmailAuthErrors {
        fn from(value: InvalidInitialization) -> Self {
            Self::InvalidInitialization(value)
        }
    }
    impl ::core::convert::From<NotInitializing> for EmailAuthErrors {
        fn from(value: NotInitializing) -> Self {
            Self::NotInitializing(value)
        }
    }
    impl ::core::convert::From<OwnableInvalidOwner> for EmailAuthErrors {
        fn from(value: OwnableInvalidOwner) -> Self {
            Self::OwnableInvalidOwner(value)
        }
    }
    impl ::core::convert::From<OwnableUnauthorizedAccount> for EmailAuthErrors {
        fn from(value: OwnableUnauthorizedAccount) -> Self {
            Self::OwnableUnauthorizedAccount(value)
        }
    }
    impl ::core::convert::From<UUPSUnauthorizedCallContext> for EmailAuthErrors {
        fn from(value: UUPSUnauthorizedCallContext) -> Self {
            Self::UUPSUnauthorizedCallContext(value)
        }
    }
    impl ::core::convert::From<UUPSUnsupportedProxiableUUID> for EmailAuthErrors {
        fn from(value: UUPSUnsupportedProxiableUUID) -> Self {
            Self::UUPSUnsupportedProxiableUUID(value)
        }
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "DKIMRegistryUpdated", abi = "DKIMRegistryUpdated(address)")]
    pub struct DkimregistryUpdatedFilter {
        #[ethevent(indexed)]
        pub dkim_registry: ::ethers::core::types::Address,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(
        name = "EmailAuthed",
        abi = "EmailAuthed(bytes32,bytes32,bytes32,bool,uint256)"
    )]
    pub struct EmailAuthedFilter {
        #[ethevent(indexed)]
        pub email_nullifier: [u8; 32],
        #[ethevent(indexed)]
        pub msg_hash: [u8; 32],
        #[ethevent(indexed)]
        pub account_salt: [u8; 32],
        pub is_code_exist: bool,
        pub template_id: ::ethers::core::types::U256,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "Initialized", abi = "Initialized(uint64)")]
    pub struct InitializedFilter {
        pub version: u64,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(
        name = "OwnershipTransferred",
        abi = "OwnershipTransferred(address,address)"
    )]
    pub struct OwnershipTransferredFilter {
        #[ethevent(indexed)]
        pub previous_owner: ::ethers::core::types::Address,
        #[ethevent(indexed)]
        pub new_owner: ::ethers::core::types::Address,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "SubjectTemplateDeleted", abi = "SubjectTemplateDeleted(uint256)")]
    pub struct SubjectTemplateDeletedFilter {
        #[ethevent(indexed)]
        pub template_id: ::ethers::core::types::U256,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(
        name = "SubjectTemplateInserted",
        abi = "SubjectTemplateInserted(uint256)"
    )]
    pub struct SubjectTemplateInsertedFilter {
        #[ethevent(indexed)]
        pub template_id: ::ethers::core::types::U256,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "SubjectTemplateUpdated", abi = "SubjectTemplateUpdated(uint256)")]
    pub struct SubjectTemplateUpdatedFilter {
        #[ethevent(indexed)]
        pub template_id: ::ethers::core::types::U256,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "TimestampCheckEnabled", abi = "TimestampCheckEnabled(bool)")]
    pub struct TimestampCheckEnabledFilter {
        pub enabled: bool,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "Upgraded", abi = "Upgraded(address)")]
    pub struct UpgradedFilter {
        #[ethevent(indexed)]
        pub implementation: ::ethers::core::types::Address,
    }
    #[derive(
        Clone,
        ::ethers::contract::EthEvent,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethevent(name = "VerifierUpdated", abi = "VerifierUpdated(address)")]
    pub struct VerifierUpdatedFilter {
        #[ethevent(indexed)]
        pub verifier: ::ethers::core::types::Address,
    }
    ///Container type for all of the contract's events
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum EmailAuthEvents {
        DkimregistryUpdatedFilter(DkimregistryUpdatedFilter),
        EmailAuthedFilter(EmailAuthedFilter),
        InitializedFilter(InitializedFilter),
        OwnershipTransferredFilter(OwnershipTransferredFilter),
        SubjectTemplateDeletedFilter(SubjectTemplateDeletedFilter),
        SubjectTemplateInsertedFilter(SubjectTemplateInsertedFilter),
        SubjectTemplateUpdatedFilter(SubjectTemplateUpdatedFilter),
        TimestampCheckEnabledFilter(TimestampCheckEnabledFilter),
        UpgradedFilter(UpgradedFilter),
        VerifierUpdatedFilter(VerifierUpdatedFilter),
    }
    impl ::ethers::contract::EthLogDecode for EmailAuthEvents {
        fn decode_log(
            log: &::ethers::core::abi::RawLog,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::Error> {
            if let Ok(decoded) = DkimregistryUpdatedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::DkimregistryUpdatedFilter(decoded));
            }
            if let Ok(decoded) = EmailAuthedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::EmailAuthedFilter(decoded));
            }
            if let Ok(decoded) = InitializedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::InitializedFilter(decoded));
            }
            if let Ok(decoded) = OwnershipTransferredFilter::decode_log(log) {
                return Ok(EmailAuthEvents::OwnershipTransferredFilter(decoded));
            }
            if let Ok(decoded) = SubjectTemplateDeletedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::SubjectTemplateDeletedFilter(decoded));
            }
            if let Ok(decoded) = SubjectTemplateInsertedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::SubjectTemplateInsertedFilter(decoded));
            }
            if let Ok(decoded) = SubjectTemplateUpdatedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::SubjectTemplateUpdatedFilter(decoded));
            }
            if let Ok(decoded) = TimestampCheckEnabledFilter::decode_log(log) {
                return Ok(EmailAuthEvents::TimestampCheckEnabledFilter(decoded));
            }
            if let Ok(decoded) = UpgradedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::UpgradedFilter(decoded));
            }
            if let Ok(decoded) = VerifierUpdatedFilter::decode_log(log) {
                return Ok(EmailAuthEvents::VerifierUpdatedFilter(decoded));
            }
            Err(::ethers::core::abi::Error::InvalidData)
        }
    }
    impl ::core::fmt::Display for EmailAuthEvents {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::DkimregistryUpdatedFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::EmailAuthedFilter(element) => ::core::fmt::Display::fmt(element, f),
                Self::InitializedFilter(element) => ::core::fmt::Display::fmt(element, f),
                Self::OwnershipTransferredFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::SubjectTemplateDeletedFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::SubjectTemplateInsertedFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::SubjectTemplateUpdatedFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::TimestampCheckEnabledFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::UpgradedFilter(element) => ::core::fmt::Display::fmt(element, f),
                Self::VerifierUpdatedFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
            }
        }
    }
    impl ::core::convert::From<DkimregistryUpdatedFilter> for EmailAuthEvents {
        fn from(value: DkimregistryUpdatedFilter) -> Self {
            Self::DkimregistryUpdatedFilter(value)
        }
    }
    impl ::core::convert::From<EmailAuthedFilter> for EmailAuthEvents {
        fn from(value: EmailAuthedFilter) -> Self {
            Self::EmailAuthedFilter(value)
        }
    }
    impl ::core::convert::From<InitializedFilter> for EmailAuthEvents {
        fn from(value: InitializedFilter) -> Self {
            Self::InitializedFilter(value)
        }
    }
    impl ::core::convert::From<OwnershipTransferredFilter> for EmailAuthEvents {
        fn from(value: OwnershipTransferredFilter) -> Self {
            Self::OwnershipTransferredFilter(value)
        }
    }
    impl ::core::convert::From<SubjectTemplateDeletedFilter> for EmailAuthEvents {
        fn from(value: SubjectTemplateDeletedFilter) -> Self {
            Self::SubjectTemplateDeletedFilter(value)
        }
    }
    impl ::core::convert::From<SubjectTemplateInsertedFilter> for EmailAuthEvents {
        fn from(value: SubjectTemplateInsertedFilter) -> Self {
            Self::SubjectTemplateInsertedFilter(value)
        }
    }
    impl ::core::convert::From<SubjectTemplateUpdatedFilter> for EmailAuthEvents {
        fn from(value: SubjectTemplateUpdatedFilter) -> Self {
            Self::SubjectTemplateUpdatedFilter(value)
        }
    }
    impl ::core::convert::From<TimestampCheckEnabledFilter> for EmailAuthEvents {
        fn from(value: TimestampCheckEnabledFilter) -> Self {
            Self::TimestampCheckEnabledFilter(value)
        }
    }
    impl ::core::convert::From<UpgradedFilter> for EmailAuthEvents {
        fn from(value: UpgradedFilter) -> Self {
            Self::UpgradedFilter(value)
        }
    }
    impl ::core::convert::From<VerifierUpdatedFilter> for EmailAuthEvents {
        fn from(value: VerifierUpdatedFilter) -> Self {
            Self::VerifierUpdatedFilter(value)
        }
    }
    ///Container type for all input parameters for the `UPGRADE_INTERFACE_VERSION` function with signature `UPGRADE_INTERFACE_VERSION()` and selector `0xad3cb1cc`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "UPGRADE_INTERFACE_VERSION", abi = "UPGRADE_INTERFACE_VERSION()")]
    pub struct UpgradeInterfaceVersionCall;
    ///Container type for all input parameters for the `accountSalt` function with signature `accountSalt()` and selector `0x6c74921e`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "accountSalt", abi = "accountSalt()")]
    pub struct AccountSaltCall;
    ///Container type for all input parameters for the `authEmail` function with signature `authEmail((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)))` and selector `0xad3f5f9b`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(
        name = "authEmail",
        abi = "authEmail((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)))"
    )]
    pub struct AuthEmailCall {
        pub email_auth_msg: EmailAuthMsg,
    }
    ///Container type for all input parameters for the `authedHash` function with signature `authedHash(bytes32)` and selector `0x805811ec`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "authedHash", abi = "authedHash(bytes32)")]
    pub struct AuthedHashCall(pub [u8; 32]);
    ///Container type for all input parameters for the `computeMsgHash` function with signature `computeMsgHash(bytes32,bool,uint256,bytes[])` and selector `0x2bde033d`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(
        name = "computeMsgHash",
        abi = "computeMsgHash(bytes32,bool,uint256,bytes[])"
    )]
    pub struct ComputeMsgHashCall {
        pub account_salt: [u8; 32],
        pub is_code_exist: bool,
        pub template_id: ::ethers::core::types::U256,
        pub subject_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
    }
    ///Container type for all input parameters for the `deleteSubjectTemplate` function with signature `deleteSubjectTemplate(uint256)` and selector `0x519e50d1`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "deleteSubjectTemplate", abi = "deleteSubjectTemplate(uint256)")]
    pub struct DeleteSubjectTemplateCall {
        pub template_id: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `dkim` function with signature `dkim()` and selector `0x400ad5ce`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "dkim", abi = "dkim()")]
    pub struct DkimCall;
    ///Container type for all input parameters for the `dkimRegistryAddr` function with signature `dkimRegistryAddr()` and selector `0x1bc01b83`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "dkimRegistryAddr", abi = "dkimRegistryAddr()")]
    pub struct DkimRegistryAddrCall;
    ///Container type for all input parameters for the `getSubjectTemplate` function with signature `getSubjectTemplate(uint256)` and selector `0x1e05a028`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "getSubjectTemplate", abi = "getSubjectTemplate(uint256)")]
    pub struct GetSubjectTemplateCall {
        pub template_id: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `initialize` function with signature `initialize(address,bytes32)` and selector `0xbe13f47c`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "initialize", abi = "initialize(address,bytes32)")]
    pub struct InitializeCall {
        pub initial_owner: ::ethers::core::types::Address,
        pub account_salt: [u8; 32],
    }
    ///Container type for all input parameters for the `insertSubjectTemplate` function with signature `insertSubjectTemplate(uint256,string[])` and selector `0xc4b84df4`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(
        name = "insertSubjectTemplate",
        abi = "insertSubjectTemplate(uint256,string[])"
    )]
    pub struct InsertSubjectTemplateCall {
        pub template_id: ::ethers::core::types::U256,
        pub subject_template: ::std::vec::Vec<::std::string::String>,
    }
    ///Container type for all input parameters for the `isValidSignature` function with signature `isValidSignature(bytes32,bytes)` and selector `0x1626ba7e`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "isValidSignature", abi = "isValidSignature(bytes32,bytes)")]
    pub struct IsValidSignatureCall {
        pub hash: [u8; 32],
        pub signature: ::ethers::core::types::Bytes,
    }
    ///Container type for all input parameters for the `lastTimestamp` function with signature `lastTimestamp()` and selector `0x19d8ac61`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "lastTimestamp", abi = "lastTimestamp()")]
    pub struct LastTimestampCall;
    ///Container type for all input parameters for the `owner` function with signature `owner()` and selector `0x8da5cb5b`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "owner", abi = "owner()")]
    pub struct OwnerCall;
    ///Container type for all input parameters for the `proxiableUUID` function with signature `proxiableUUID()` and selector `0x52d1902d`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "proxiableUUID", abi = "proxiableUUID()")]
    pub struct ProxiableUUIDCall;
    ///Container type for all input parameters for the `renounceOwnership` function with signature `renounceOwnership()` and selector `0x715018a6`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "renounceOwnership", abi = "renounceOwnership()")]
    pub struct RenounceOwnershipCall;
    ///Container type for all input parameters for the `setTimestampCheckEnabled` function with signature `setTimestampCheckEnabled(bool)` and selector `0xe453c0f3`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "setTimestampCheckEnabled", abi = "setTimestampCheckEnabled(bool)")]
    pub struct SetTimestampCheckEnabledCall {
        pub enabled: bool,
    }
    ///Container type for all input parameters for the `subjectTemplates` function with signature `subjectTemplates(uint256,uint256)` and selector `0x4bd07760`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "subjectTemplates", abi = "subjectTemplates(uint256,uint256)")]
    pub struct SubjectTemplatesCall(
        pub ::ethers::core::types::U256,
        pub ::ethers::core::types::U256,
    );
    ///Container type for all input parameters for the `timestampCheckEnabled` function with signature `timestampCheckEnabled()` and selector `0x3e56f529`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "timestampCheckEnabled", abi = "timestampCheckEnabled()")]
    pub struct TimestampCheckEnabledCall;
    ///Container type for all input parameters for the `transferOwnership` function with signature `transferOwnership(address)` and selector `0xf2fde38b`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "transferOwnership", abi = "transferOwnership(address)")]
    pub struct TransferOwnershipCall {
        pub new_owner: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `updateDKIMRegistry` function with signature `updateDKIMRegistry(address)` and selector `0xa500125c`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "updateDKIMRegistry", abi = "updateDKIMRegistry(address)")]
    pub struct UpdateDKIMRegistryCall {
        pub dkim_registry_addr: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `updateSubjectTemplate` function with signature `updateSubjectTemplate(uint256,string[])` and selector `0x4dbb82f1`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(
        name = "updateSubjectTemplate",
        abi = "updateSubjectTemplate(uint256,string[])"
    )]
    pub struct UpdateSubjectTemplateCall {
        pub template_id: ::ethers::core::types::U256,
        pub subject_template: ::std::vec::Vec<::std::string::String>,
    }
    ///Container type for all input parameters for the `updateVerifier` function with signature `updateVerifier(address)` and selector `0x97fc007c`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "updateVerifier", abi = "updateVerifier(address)")]
    pub struct UpdateVerifierCall {
        pub verifier_addr: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `upgradeToAndCall` function with signature `upgradeToAndCall(address,bytes)` and selector `0x4f1ef286`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "upgradeToAndCall", abi = "upgradeToAndCall(address,bytes)")]
    pub struct UpgradeToAndCallCall {
        pub new_implementation: ::ethers::core::types::Address,
        pub data: ::ethers::core::types::Bytes,
    }
    ///Container type for all input parameters for the `usedNullifiers` function with signature `usedNullifiers(bytes32)` and selector `0x206137aa`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "usedNullifiers", abi = "usedNullifiers(bytes32)")]
    pub struct UsedNullifiersCall(pub [u8; 32]);
    ///Container type for all input parameters for the `verifier` function with signature `verifier()` and selector `0x2b7ac3f3`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "verifier", abi = "verifier()")]
    pub struct VerifierCall;
    ///Container type for all input parameters for the `verifierAddr` function with signature `verifierAddr()` and selector `0x663ea2e2`
    #[derive(
        Clone,
        ::ethers::contract::EthCall,
        ::ethers::contract::EthDisplay,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    #[ethcall(name = "verifierAddr", abi = "verifierAddr()")]
    pub struct VerifierAddrCall;
    ///Container type for all of the contract's call
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum EmailAuthCalls {
        UpgradeInterfaceVersion(UpgradeInterfaceVersionCall),
        AccountSalt(AccountSaltCall),
        AuthEmail(AuthEmailCall),
        AuthedHash(AuthedHashCall),
        ComputeMsgHash(ComputeMsgHashCall),
        DeleteSubjectTemplate(DeleteSubjectTemplateCall),
        Dkim(DkimCall),
        DkimRegistryAddr(DkimRegistryAddrCall),
        GetSubjectTemplate(GetSubjectTemplateCall),
        Initialize(InitializeCall),
        InsertSubjectTemplate(InsertSubjectTemplateCall),
        IsValidSignature(IsValidSignatureCall),
        LastTimestamp(LastTimestampCall),
        Owner(OwnerCall),
        ProxiableUUID(ProxiableUUIDCall),
        RenounceOwnership(RenounceOwnershipCall),
        SetTimestampCheckEnabled(SetTimestampCheckEnabledCall),
        SubjectTemplates(SubjectTemplatesCall),
        TimestampCheckEnabled(TimestampCheckEnabledCall),
        TransferOwnership(TransferOwnershipCall),
        UpdateDKIMRegistry(UpdateDKIMRegistryCall),
        UpdateSubjectTemplate(UpdateSubjectTemplateCall),
        UpdateVerifier(UpdateVerifierCall),
        UpgradeToAndCall(UpgradeToAndCallCall),
        UsedNullifiers(UsedNullifiersCall),
        Verifier(VerifierCall),
        VerifierAddr(VerifierAddrCall),
    }
    impl ::ethers::core::abi::AbiDecode for EmailAuthCalls {
        fn decode(
            data: impl AsRef<[u8]>,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::AbiError> {
            let data = data.as_ref();
            if let Ok(decoded) = <UpgradeInterfaceVersionCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UpgradeInterfaceVersion(decoded));
            }
            if let Ok(decoded) = <AccountSaltCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AccountSalt(decoded));
            }
            if let Ok(decoded) = <AuthEmailCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AuthEmail(decoded));
            }
            if let Ok(decoded) = <AuthedHashCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AuthedHash(decoded));
            }
            if let Ok(decoded) = <ComputeMsgHashCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ComputeMsgHash(decoded));
            }
            if let Ok(decoded) = <DeleteSubjectTemplateCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::DeleteSubjectTemplate(decoded));
            }
            if let Ok(decoded) = <DkimCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Dkim(decoded));
            }
            if let Ok(decoded) = <DkimRegistryAddrCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::DkimRegistryAddr(decoded));
            }
            if let Ok(decoded) = <GetSubjectTemplateCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::GetSubjectTemplate(decoded));
            }
            if let Ok(decoded) = <InitializeCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Initialize(decoded));
            }
            if let Ok(decoded) = <InsertSubjectTemplateCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::InsertSubjectTemplate(decoded));
            }
            if let Ok(decoded) = <IsValidSignatureCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::IsValidSignature(decoded));
            }
            if let Ok(decoded) = <LastTimestampCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::LastTimestamp(decoded));
            }
            if let Ok(decoded) = <OwnerCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Owner(decoded));
            }
            if let Ok(decoded) = <ProxiableUUIDCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ProxiableUUID(decoded));
            }
            if let Ok(decoded) = <RenounceOwnershipCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RenounceOwnership(decoded));
            }
            if let Ok(decoded) = <SetTimestampCheckEnabledCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::SetTimestampCheckEnabled(decoded));
            }
            if let Ok(decoded) = <SubjectTemplatesCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::SubjectTemplates(decoded));
            }
            if let Ok(decoded) = <TimestampCheckEnabledCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::TimestampCheckEnabled(decoded));
            }
            if let Ok(decoded) = <TransferOwnershipCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::TransferOwnership(decoded));
            }
            if let Ok(decoded) = <UpdateDKIMRegistryCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UpdateDKIMRegistry(decoded));
            }
            if let Ok(decoded) = <UpdateSubjectTemplateCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UpdateSubjectTemplate(decoded));
            }
            if let Ok(decoded) = <UpdateVerifierCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UpdateVerifier(decoded));
            }
            if let Ok(decoded) = <UpgradeToAndCallCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UpgradeToAndCall(decoded));
            }
            if let Ok(decoded) = <UsedNullifiersCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::UsedNullifiers(decoded));
            }
            if let Ok(decoded) = <VerifierCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Verifier(decoded));
            }
            if let Ok(decoded) = <VerifierAddrCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::VerifierAddr(decoded));
            }
            Err(::ethers::core::abi::Error::InvalidData.into())
        }
    }
    impl ::ethers::core::abi::AbiEncode for EmailAuthCalls {
        fn encode(self) -> Vec<u8> {
            match self {
                Self::UpgradeInterfaceVersion(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::AccountSalt(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::AuthEmail(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::AuthedHash(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ComputeMsgHash(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::DeleteSubjectTemplate(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Dkim(element) => ::ethers::core::abi::AbiEncode::encode(element),
                Self::DkimRegistryAddr(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::GetSubjectTemplate(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Initialize(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::InsertSubjectTemplate(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::IsValidSignature(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::LastTimestamp(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Owner(element) => ::ethers::core::abi::AbiEncode::encode(element),
                Self::ProxiableUUID(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RenounceOwnership(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::SetTimestampCheckEnabled(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::SubjectTemplates(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::TimestampCheckEnabled(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::TransferOwnership(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UpdateDKIMRegistry(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UpdateSubjectTemplate(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UpdateVerifier(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UpgradeToAndCall(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::UsedNullifiers(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Verifier(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::VerifierAddr(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
            }
        }
    }
    impl ::core::fmt::Display for EmailAuthCalls {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::UpgradeInterfaceVersion(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::AccountSalt(element) => ::core::fmt::Display::fmt(element, f),
                Self::AuthEmail(element) => ::core::fmt::Display::fmt(element, f),
                Self::AuthedHash(element) => ::core::fmt::Display::fmt(element, f),
                Self::ComputeMsgHash(element) => ::core::fmt::Display::fmt(element, f),
                Self::DeleteSubjectTemplate(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Dkim(element) => ::core::fmt::Display::fmt(element, f),
                Self::DkimRegistryAddr(element) => ::core::fmt::Display::fmt(element, f),
                Self::GetSubjectTemplate(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Initialize(element) => ::core::fmt::Display::fmt(element, f),
                Self::InsertSubjectTemplate(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::IsValidSignature(element) => ::core::fmt::Display::fmt(element, f),
                Self::LastTimestamp(element) => ::core::fmt::Display::fmt(element, f),
                Self::Owner(element) => ::core::fmt::Display::fmt(element, f),
                Self::ProxiableUUID(element) => ::core::fmt::Display::fmt(element, f),
                Self::RenounceOwnership(element) => ::core::fmt::Display::fmt(element, f),
                Self::SetTimestampCheckEnabled(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::SubjectTemplates(element) => ::core::fmt::Display::fmt(element, f),
                Self::TimestampCheckEnabled(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::TransferOwnership(element) => ::core::fmt::Display::fmt(element, f),
                Self::UpdateDKIMRegistry(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::UpdateSubjectTemplate(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::UpdateVerifier(element) => ::core::fmt::Display::fmt(element, f),
                Self::UpgradeToAndCall(element) => ::core::fmt::Display::fmt(element, f),
                Self::UsedNullifiers(element) => ::core::fmt::Display::fmt(element, f),
                Self::Verifier(element) => ::core::fmt::Display::fmt(element, f),
                Self::VerifierAddr(element) => ::core::fmt::Display::fmt(element, f),
            }
        }
    }
    impl ::core::convert::From<UpgradeInterfaceVersionCall> for EmailAuthCalls {
        fn from(value: UpgradeInterfaceVersionCall) -> Self {
            Self::UpgradeInterfaceVersion(value)
        }
    }
    impl ::core::convert::From<AccountSaltCall> for EmailAuthCalls {
        fn from(value: AccountSaltCall) -> Self {
            Self::AccountSalt(value)
        }
    }
    impl ::core::convert::From<AuthEmailCall> for EmailAuthCalls {
        fn from(value: AuthEmailCall) -> Self {
            Self::AuthEmail(value)
        }
    }
    impl ::core::convert::From<AuthedHashCall> for EmailAuthCalls {
        fn from(value: AuthedHashCall) -> Self {
            Self::AuthedHash(value)
        }
    }
    impl ::core::convert::From<ComputeMsgHashCall> for EmailAuthCalls {
        fn from(value: ComputeMsgHashCall) -> Self {
            Self::ComputeMsgHash(value)
        }
    }
    impl ::core::convert::From<DeleteSubjectTemplateCall> for EmailAuthCalls {
        fn from(value: DeleteSubjectTemplateCall) -> Self {
            Self::DeleteSubjectTemplate(value)
        }
    }
    impl ::core::convert::From<DkimCall> for EmailAuthCalls {
        fn from(value: DkimCall) -> Self {
            Self::Dkim(value)
        }
    }
    impl ::core::convert::From<DkimRegistryAddrCall> for EmailAuthCalls {
        fn from(value: DkimRegistryAddrCall) -> Self {
            Self::DkimRegistryAddr(value)
        }
    }
    impl ::core::convert::From<GetSubjectTemplateCall> for EmailAuthCalls {
        fn from(value: GetSubjectTemplateCall) -> Self {
            Self::GetSubjectTemplate(value)
        }
    }
    impl ::core::convert::From<InitializeCall> for EmailAuthCalls {
        fn from(value: InitializeCall) -> Self {
            Self::Initialize(value)
        }
    }
    impl ::core::convert::From<InsertSubjectTemplateCall> for EmailAuthCalls {
        fn from(value: InsertSubjectTemplateCall) -> Self {
            Self::InsertSubjectTemplate(value)
        }
    }
    impl ::core::convert::From<IsValidSignatureCall> for EmailAuthCalls {
        fn from(value: IsValidSignatureCall) -> Self {
            Self::IsValidSignature(value)
        }
    }
    impl ::core::convert::From<LastTimestampCall> for EmailAuthCalls {
        fn from(value: LastTimestampCall) -> Self {
            Self::LastTimestamp(value)
        }
    }
    impl ::core::convert::From<OwnerCall> for EmailAuthCalls {
        fn from(value: OwnerCall) -> Self {
            Self::Owner(value)
        }
    }
    impl ::core::convert::From<ProxiableUUIDCall> for EmailAuthCalls {
        fn from(value: ProxiableUUIDCall) -> Self {
            Self::ProxiableUUID(value)
        }
    }
    impl ::core::convert::From<RenounceOwnershipCall> for EmailAuthCalls {
        fn from(value: RenounceOwnershipCall) -> Self {
            Self::RenounceOwnership(value)
        }
    }
    impl ::core::convert::From<SetTimestampCheckEnabledCall> for EmailAuthCalls {
        fn from(value: SetTimestampCheckEnabledCall) -> Self {
            Self::SetTimestampCheckEnabled(value)
        }
    }
    impl ::core::convert::From<SubjectTemplatesCall> for EmailAuthCalls {
        fn from(value: SubjectTemplatesCall) -> Self {
            Self::SubjectTemplates(value)
        }
    }
    impl ::core::convert::From<TimestampCheckEnabledCall> for EmailAuthCalls {
        fn from(value: TimestampCheckEnabledCall) -> Self {
            Self::TimestampCheckEnabled(value)
        }
    }
    impl ::core::convert::From<TransferOwnershipCall> for EmailAuthCalls {
        fn from(value: TransferOwnershipCall) -> Self {
            Self::TransferOwnership(value)
        }
    }
    impl ::core::convert::From<UpdateDKIMRegistryCall> for EmailAuthCalls {
        fn from(value: UpdateDKIMRegistryCall) -> Self {
            Self::UpdateDKIMRegistry(value)
        }
    }
    impl ::core::convert::From<UpdateSubjectTemplateCall> for EmailAuthCalls {
        fn from(value: UpdateSubjectTemplateCall) -> Self {
            Self::UpdateSubjectTemplate(value)
        }
    }
    impl ::core::convert::From<UpdateVerifierCall> for EmailAuthCalls {
        fn from(value: UpdateVerifierCall) -> Self {
            Self::UpdateVerifier(value)
        }
    }
    impl ::core::convert::From<UpgradeToAndCallCall> for EmailAuthCalls {
        fn from(value: UpgradeToAndCallCall) -> Self {
            Self::UpgradeToAndCall(value)
        }
    }
    impl ::core::convert::From<UsedNullifiersCall> for EmailAuthCalls {
        fn from(value: UsedNullifiersCall) -> Self {
            Self::UsedNullifiers(value)
        }
    }
    impl ::core::convert::From<VerifierCall> for EmailAuthCalls {
        fn from(value: VerifierCall) -> Self {
            Self::Verifier(value)
        }
    }
    impl ::core::convert::From<VerifierAddrCall> for EmailAuthCalls {
        fn from(value: VerifierAddrCall) -> Self {
            Self::VerifierAddr(value)
        }
    }
    ///Container type for all return fields from the `UPGRADE_INTERFACE_VERSION` function with signature `UPGRADE_INTERFACE_VERSION()` and selector `0xad3cb1cc`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct UpgradeInterfaceVersionReturn(pub ::std::string::String);
    ///Container type for all return fields from the `accountSalt` function with signature `accountSalt()` and selector `0x6c74921e`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct AccountSaltReturn(pub [u8; 32]);
    ///Container type for all return fields from the `authEmail` function with signature `authEmail((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)))` and selector `0xad3f5f9b`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct AuthEmailReturn(pub [u8; 32]);
    ///Container type for all return fields from the `authedHash` function with signature `authedHash(bytes32)` and selector `0x805811ec`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct AuthedHashReturn(pub [u8; 32]);
    ///Container type for all return fields from the `computeMsgHash` function with signature `computeMsgHash(bytes32,bool,uint256,bytes[])` and selector `0x2bde033d`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct ComputeMsgHashReturn(pub [u8; 32]);
    ///Container type for all return fields from the `dkim` function with signature `dkim()` and selector `0x400ad5ce`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct DkimReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `dkimRegistryAddr` function with signature `dkimRegistryAddr()` and selector `0x1bc01b83`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct DkimRegistryAddrReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `getSubjectTemplate` function with signature `getSubjectTemplate(uint256)` and selector `0x1e05a028`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct GetSubjectTemplateReturn(pub ::std::vec::Vec<::std::string::String>);
    ///Container type for all return fields from the `isValidSignature` function with signature `isValidSignature(bytes32,bytes)` and selector `0x1626ba7e`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct IsValidSignatureReturn(pub [u8; 4]);
    ///Container type for all return fields from the `lastTimestamp` function with signature `lastTimestamp()` and selector `0x19d8ac61`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct LastTimestampReturn(pub ::ethers::core::types::U256);
    ///Container type for all return fields from the `owner` function with signature `owner()` and selector `0x8da5cb5b`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct OwnerReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `proxiableUUID` function with signature `proxiableUUID()` and selector `0x52d1902d`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct ProxiableUUIDReturn(pub [u8; 32]);
    ///Container type for all return fields from the `subjectTemplates` function with signature `subjectTemplates(uint256,uint256)` and selector `0x4bd07760`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct SubjectTemplatesReturn(pub ::std::string::String);
    ///Container type for all return fields from the `timestampCheckEnabled` function with signature `timestampCheckEnabled()` and selector `0x3e56f529`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct TimestampCheckEnabledReturn(pub bool);
    ///Container type for all return fields from the `usedNullifiers` function with signature `usedNullifiers(bytes32)` and selector `0x206137aa`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct UsedNullifiersReturn(pub bool);
    ///Container type for all return fields from the `verifier` function with signature `verifier()` and selector `0x2b7ac3f3`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct VerifierReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `verifierAddr` function with signature `verifierAddr()` and selector `0x663ea2e2`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct VerifierAddrReturn(pub ::ethers::core::types::Address);
    ///`EmailAuthMsg(uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes))`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct EmailAuthMsg {
        pub template_id: ::ethers::core::types::U256,
        pub subject_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
        pub skiped_subject_prefix: ::ethers::core::types::U256,
        pub proof: EmailProof,
    }
    ///`EmailProof(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)`
    #[derive(
        Clone,
        ::ethers::contract::EthAbiType,
        ::ethers::contract::EthAbiCodec,
        Default,
        Debug,
        PartialEq,
        Eq,
        Hash
    )]
    pub struct EmailProof {
        pub domain_name: ::std::string::String,
        pub public_key_hash: [u8; 32],
        pub timestamp: ::ethers::core::types::U256,
        pub masked_subject: ::std::string::String,
        pub email_nullifier: [u8; 32],
        pub account_salt: [u8; 32],
        pub is_code_exist: bool,
        pub proof: ::ethers::core::types::Bytes,
    }
}
