pub use simple_wallet::*;
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
pub mod simple_wallet {
    #[allow(deprecated)]
    fn __abi() -> ::ethers::core::abi::Abi {
        ::ethers::core::abi::ethabi::Contract {
            constructor: ::core::option::Option::Some(::ethers::core::abi::ethabi::Constructor {
                inputs: ::std::vec![],
            }),
            functions: ::core::convert::From::from([
                (
                    ::std::borrow::ToOwned::to_owned("TIMELOCK_PERIOD"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("TIMELOCK_PERIOD"),
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
                    ::std::borrow::ToOwned::to_owned("acceptanceSubjectTemplates"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "acceptanceSubjectTemplates",
                            ),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::Array(
                                                ::std::boxed::Box::new(
                                                    ::ethers::core::abi::ethabi::ParamType::String,
                                                ),
                                            ),
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string[][]"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Pure,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("completeRecovery"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("completeRecovery"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("computeAcceptanceTemplateId"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "computeAcceptanceTemplateId",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("templateIdx"),
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
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Pure,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("computeEmailAuthAddress"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "computeEmailAuthAddress",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("accountSalt"),
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
                    ::std::borrow::ToOwned::to_owned("computeRecoveryTemplateId"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "computeRecoveryTemplateId",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("templateIdx"),
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
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(
                                        256usize,
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("uint256"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Pure,
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
                    ::std::borrow::ToOwned::to_owned("dkimAddr"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("dkimAddr"),
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
                    ::std::borrow::ToOwned::to_owned("emailAuthImplementation"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "emailAuthImplementation",
                            ),
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
                    ::std::borrow::ToOwned::to_owned("emailAuthImplementationAddr"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "emailAuthImplementationAddr",
                            ),
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
                    ::std::borrow::ToOwned::to_owned("guardians"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("guardians"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                            ],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Uint(8usize),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned(
                                            "enum SimpleWallet.GuardianStatus",
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
                    ::std::borrow::ToOwned::to_owned("handleAcceptance"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("handleAcceptance"),
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
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("templateIdx"),
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
                    ::std::borrow::ToOwned::to_owned("handleRecovery"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("handleRecovery"),
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
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("templateIdx"),
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
                                    name: ::std::borrow::ToOwned::to_owned("_verifier"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("_dkim"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned(
                                        "_emailAuthImplementation",
                                    ),
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
                    ::std::borrow::ToOwned::to_owned("isRecovering"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("isRecovering"),
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
                    ::std::borrow::ToOwned::to_owned("newSignerCandidate"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("newSignerCandidate"),
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
                    ::std::borrow::ToOwned::to_owned("recoverySubjectTemplates"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "recoverySubjectTemplates",
                            ),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::string::String::new(),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::Array(
                                                ::std::boxed::Box::new(
                                                    ::ethers::core::abi::ethabi::ParamType::String,
                                                ),
                                            ),
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("string[][]"),
                                    ),
                                },
                            ],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::Pure,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("rejectRecovery"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("rejectRecovery"),
                            inputs: ::std::vec![],
                            outputs: ::std::vec![],
                            constant: ::core::option::Option::None,
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::NonPayable,
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
                    ::std::borrow::ToOwned::to_owned("requestGuardian"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("requestGuardian"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("guardian"),
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
                    ::std::borrow::ToOwned::to_owned("timelock"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("timelock"),
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
                    ::std::borrow::ToOwned::to_owned("transfer"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("transfer"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("to"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("amount"),
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
                (
                    ::std::borrow::ToOwned::to_owned("withdraw"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("withdraw"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("amount"),
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
            ]),
            events: ::core::convert::From::from([
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
            ]),
            errors: ::core::convert::From::from([
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
            ]),
            receive: true,
            fallback: true,
        }
    }
    ///The parsed JSON ABI of the contract.
    pub static SIMPLEWALLET_ABI: ::ethers::contract::Lazy<::ethers::core::abi::Abi> = ::ethers::contract::Lazy::new(
        __abi,
    );
    #[rustfmt::skip]
    const __BYTECODE: &[u8] = b"`\x80`@R4\x80\x15a\0\x10W`\0\x80\xFD[Pa8\x12\x80a\0 `\09`\0\xF3\xFE`\x80`@R`\x046\x10b\0\x01\xDBW`\x005`\xE0\x1C\x80cqP\x18\xA6\x11b\0\x01\x03W\x80c\xB6 \x16\x92\x11b\0\0\x97W\x80c\xD4F\xBB\x9A\x11b\0\0mW\x80c\xD4F\xBB\x9A\x14b\0\x06\xB9W\x80c\xDB\xEB\x88*\x14b\0\x06\xD1W\x80c\xF2\xFD\xE3\x8B\x14b\0\x06\xF6W\x80c\xF8\xC8v^\x14b\0\x07\x1BWb\0\x02TV[\x80c\xB6 \x16\x92\x14b\0\x06OW\x80c\xB6\x81&\xFA\x14b\0\x06|W\x80c\xD32\x19\xB4\x14b\0\x06\xA1Wb\0\x02TV[\x80c\x81R\x07\x82\x11b\0\0\xD9W\x80c\x81R\x07\x82\x14b\0\x05tW\x80c\x8D\xA5\xCB[\x14b\0\x05\x99W\x80c\x91\xAC'\x88\x14b\0\x05\xE5W\x80c\xA9\x05\x9C\xBB\x14b\0\x06*Wb\0\x02TV[\x80cqP\x18\xA6\x14b\0\x04\xFEW\x80cq\xCE`d\x14b\0\x05\x16W\x80cs5\x7F\x85\x14b\0\x05EWb\0\x02TV[\x80c>\x91\xCD\xCD\x11b\0\x01{W\x80c[\xAF\xAD\xDA\x11b\0\x01QW\x80c[\xAF\xAD\xDA\x14b\0\x04zW\x80cf>\xA2\xE2\x14b\0\x04\x92W\x80ck\x0Cq~\x14b\0\x04\xC1W\x80cm\xA9\x95\x15\x14b\0\x04\xD9Wb\0\x02TV[\x80c>\x91\xCD\xCD\x14b\0\x04\rW\x80c@\n\xD5\xCE\x14b\0\x044W\x80cJ[\xCB\xF8\x14b\0\x04aWb\0\x02TV[\x80c+z\xC3\xF3\x11b\0\x01\xB1W\x80c+z\xC3\xF3\x14b\0\x03\x87W\x80c.\x1A}M\x14b\0\x03\xB4W\x80c2\xCC\xC2\xF2\x14b\0\x03\xD9Wb\0\x02TV[\x80c\x04\x81\xAFg\x14b\0\x02\xC1W\x80c\x063\xB1J\x14b\0\x02\xE6W\x80c\x10\x98\xE0.\x14b\0\x032Wb\0\x02TV[6b\0\x02TW`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x02RW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01[`@Q\x80\x91\x03\x90\xFD[\0[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x02RW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[4\x80\x15b\0\x02\xCEW`\0\x80\xFD[Pb\0\x02Rb\0\x02\xE06`\x04b\0-}V[b\0\x07@V[4\x80\x15b\0\x02\xF3W`\0\x80\xFD[Pb\0\x03\x1Ab\0\x03\x056`\x04b\0.\xDEV[`\x04` R`\0\x90\x81R`@\x90 T`\xFF\x16\x81V[`@Qb\0\x03)\x91\x90b\0/-V[`@Q\x80\x91\x03\x90\xF3[4\x80\x15b\0\x03?W`\0\x80\xFD[P`\x02Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16\x81R` \x01b\0\x03)V[4\x80\x15b\0\x03\x94W`\0\x80\xFD[P`\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x03\xC1W`\0\x80\xFD[Pb\0\x02Rb\0\x03\xD36`\x04b\0/oV[b\0\r\x17V[4\x80\x15b\0\x03\xE6W`\0\x80\xFD[Pb\0\x03\xFEb\0\x03\xF86`\x04b\0/oV[b\0\x0E\x1BV[`@Q\x90\x81R` \x01b\0\x03)V[4\x80\x15b\0\x04\x1AW`\0\x80\xFD[Pb\0\x04%b\0\x0E\x86V[`@Qb\0\x03)\x91\x90b\x000;V[4\x80\x15b\0\x04AW`\0\x80\xFD[P`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x04nW`\0\x80\xFD[Pb\0\x03\xFEb\x03\xF4\x80\x81V[4\x80\x15b\0\x04\x87W`\0\x80\xFD[Pb\0\x04%b\0\x12\xABV[4\x80\x15b\0\x04\x9FW`\0\x80\xFD[P`\0Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x04\xCEW`\0\x80\xFD[Pb\0\x02Rb\0\x15cV[4\x80\x15b\0\x04\xE6W`\0\x80\xFD[Pb\0\x03\xFEb\0\x04\xF86`\x04b\0/oV[b\0\x16\x9EV[4\x80\x15b\0\x05\x0BW`\0\x80\xFD[Pb\0\x02Rb\0\x16\xF0V[4\x80\x15b\0\x05#W`\0\x80\xFD[P`\x03Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x05RW`\0\x80\xFD[P`\x01Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x05\x81W`\0\x80\xFD[Pb\0\x03ab\0\x05\x936`\x04b\0/oV[b\0\x17\x08V[4\x80\x15b\0\x05\xA6W`\0\x80\xFD[P\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x05\xF2W`\0\x80\xFD[P`\x02Tb\0\x06\x19\x90t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x81V[`@Q\x90\x15\x15\x81R` \x01b\0\x03)V[4\x80\x15b\0\x067W`\0\x80\xFD[Pb\0\x02Rb\0\x06I6`\x04b\x000\xC1V[b\0\x18\x12V[4\x80\x15b\0\x06\\W`\0\x80\xFD[P`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x06\x89W`\0\x80\xFD[Pb\0\x02Rb\0\x06\x9B6`\x04b\0-}V[b\0\x19\xA2V[4\x80\x15b\0\x06\xAEW`\0\x80\xFD[Pb\0\x03\xFE`\x05T\x81V[4\x80\x15b\0\x06\xC6W`\0\x80\xFD[Pb\0\x02Rb\0\x1B\x99V[4\x80\x15b\0\x06\xDEW`\0\x80\xFD[Pb\0\x02Rb\0\x06\xF06`\x04b\0.\xDEV[b\0\x1C\xB9V[4\x80\x15b\0\x07\x03W`\0\x80\xFD[Pb\0\x02Rb\0\x07\x156`\x04b\0.\xDEV[b\0\x1E\xEEV[4\x80\x15b\0\x07(W`\0\x80\xFD[Pb\0\x02Rb\0\x07:6`\x04b\x000\xF0V[b\0\x1FUV[`\0b\0\x07U\x83``\x01Q`\xA0\x01Qb\0\x17\x08V[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16;\x15b\0\x07\xBEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Fguardian is already deployed\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0b\0\x07\xCB\x83b\0\x0E\x1BV[\x84Q\x90\x91P\x81\x14b\0\x08 W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid template id\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[``\x84\x01Q`\xC0\x01Q\x15\x15`\x01\x14b\0\x08|W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7FisCodeExist is false\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x84``\x01Q`\xA0\x01Qb\0\x08\xA7`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[``\x87\x01Q`\xA0\x01Q`@Q0`$\x82\x01R`D\x81\x01\x91\x90\x91R`d\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x81R` \x82\x01\x80Q{\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x7F\xBE\x13\xF4|\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90RQb\0\t(\x90b\0+PV[b\0\t5\x92\x91\x90b\x001UV[\x81\x90`@Q\x80\x91\x03\x90`\0\xF5\x90P\x80\x15\x80\x15b\0\tVW=`\0\x80>=`\0\xFD[P\x90P\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16c\xA5\0\x12\\b\0\t\x96`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xE0\x84\x90\x1B\x16\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16`\x04\x82\x01R`$\x01`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\t\xFDW`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\n\x12W=`\0\x80>=`\0\xFD[PPPP\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\x97\xFC\0|b\0\nR`\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xE0\x84\x90\x1B\x16\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16`\x04\x82\x01R`$\x01`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\n\xB9W`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\n\xCEW=`\0\x80>=`\0\xFD[PPPP`\0[b\0\n\xDFb\0\x12\xABV[Q\x81\x10\x15b\0\x0B\x95W\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\xC4\xB8M\xF4b\0\x0B\x0F\x83b\0\x0E\x1BV[b\0\x0B\x19b\0\x12\xABV[\x84\x81Q\x81\x10b\0\x0B-Wb\0\x0B-b\x001\x8EV[` \x02` \x01\x01Q`@Q\x83c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01b\0\x0BT\x92\x91\x90b\x001\xBDV[`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\x0BoW`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\x0B\x84W=`\0\x80>=`\0\xFD[PP`\x01\x90\x92\x01\x91Pb\0\n\xD5\x90PV[P`\0[b\0\x0B\xA3b\0\x0E\x86V[Q\x81\x10\x15b\0\x0CYW\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\xC4\xB8M\xF4b\0\x0B\xD3\x83b\0\x16\x9EV[b\0\x0B\xDDb\0\x0E\x86V[\x84\x81Q\x81\x10b\0\x0B\xF1Wb\0\x0B\xF1b\x001\x8EV[` \x02` \x01\x01Q`@Q\x83c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01b\0\x0C\x18\x92\x91\x90b\x001\xBDV[`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\x0C3W`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\x0CHW=`\0\x80>=`\0\xFD[PP`\x01\x90\x92\x01\x91Pb\0\x0B\x99\x90PV[P`@Q\x7F\xAD?_\x9B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16\x90c\xAD?_\x9B\x90b\0\x0C\xAE\x90\x89\x90`\x04\x01b\x002eV[` `@Q\x80\x83\x03\x81`\0\x87Z\xF1\x15\x80\x15b\0\x0C\xCEW=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90b\0\x0C\xF4\x91\x90b\x003\x1DV[Pb\0\r\x0F\x84\x86\x88` \x01Q\x89``\x01Q`\x80\x01Qb\0!`V[PPPPPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\r\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x0E\x0CW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[b\0\x0E\x183\x82b\0\x18\x12V[PV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\n`\x80\x82\x01R\x7FACCEPTANCE\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x82\x90R`\0\x90`\xC0\x01[`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x90R\x80Q` \x90\x91\x01 \x92\x91PPV[`@\x80Q`\x01\x80\x82R\x81\x83\x01\x90\x92R``\x91`\0\x91\x90\x81` \x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x0E\xA1WPP`@\x80Q`\x08\x80\x82Ra\x01 \x82\x01\x90\x92R\x91\x92P` \x82\x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x0E\xCFW\x90PP\x81`\0\x81Q\x81\x10b\0\x0E\xFBWb\0\x0E\xFBb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7FSet\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x0FRWb\0\x0FRb\x001\x8EV[` \x02` \x01\x01Q`\0\x81Q\x81\x10b\0\x0FoWb\0\x0Fob\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Fthe\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x0F\xC6Wb\0\x0F\xC6b\x001\x8EV[` \x02` \x01\x01Q`\x01\x81Q\x81\x10b\0\x0F\xE3Wb\0\x0F\xE3b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Fnew\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x10:Wb\0\x10:b\x001\x8EV[` \x02` \x01\x01Q`\x02\x81Q\x81\x10b\0\x10WWb\0\x10Wb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x06\x81R` \x01\x7Fsigner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x10\xAEWb\0\x10\xAEb\x001\x8EV[` \x02` \x01\x01Q`\x03\x81Q\x81\x10b\0\x10\xCBWb\0\x10\xCBb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x02\x81R` \x01\x7Fof\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x11\"Wb\0\x11\"b\x001\x8EV[` \x02` \x01\x01Q`\x04\x81Q\x81\x10b\0\x11?Wb\0\x11?b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x11\x96Wb\0\x11\x96b\x001\x8EV[` \x02` \x01\x01Q`\x05\x81Q\x81\x10b\0\x11\xB3Wb\0\x11\xB3b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x02\x81R` \x01\x7Fto\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x12\nWb\0\x12\nb\x001\x8EV[` \x02` \x01\x01Q`\x06\x81Q\x81\x10b\0\x12'Wb\0\x12'b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x12~Wb\0\x12~b\x001\x8EV[` \x02` \x01\x01Q`\x07\x81Q\x81\x10b\0\x12\x9BWb\0\x12\x9Bb\x001\x8EV[` \x90\x81\x02\x91\x90\x91\x01\x01R\x91\x90PV[`@\x80Q`\x01\x80\x82R\x81\x83\x01\x90\x92R``\x91`\0\x91\x90\x81` \x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x12\xC6WPP`@\x80Q`\x05\x80\x82R`\xC0\x82\x01\x90\x92R\x91\x92P` \x82\x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x12\xF3W\x90PP\x81`\0\x81Q\x81\x10b\0\x13\x1FWb\0\x13\x1Fb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x06\x81R` \x01\x7FAccept\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x13vWb\0\x13vb\x001\x8EV[` \x02` \x01\x01Q`\0\x81Q\x81\x10b\0\x13\x93Wb\0\x13\x93b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x08\x81R` \x01\x7Fguardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x13\xEAWb\0\x13\xEAb\x001\x8EV[` \x02` \x01\x01Q`\x01\x81Q\x81\x10b\0\x14\x07Wb\0\x14\x07b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x07\x81R` \x01\x7Frequest\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x14^Wb\0\x14^b\x001\x8EV[` \x02` \x01\x01Q`\x02\x81Q\x81\x10b\0\x14{Wb\0\x14{b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Ffor\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x14\xD2Wb\0\x14\xD2b\x001\x8EV[` \x02` \x01\x01Q`\x03\x81Q\x81\x10b\0\x14\xEFWb\0\x14\xEFb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x15FWb\0\x15Fb\x001\x8EV[` \x02` \x01\x01Q`\x04\x81Q\x81\x10b\0\x12\x9BWb\0\x12\x9Bb\x001\x8EV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x15\xCFW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Frecovery not in progress\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[B`\x05T\x11\x15b\0\x16#W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Ftimelock not expired\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90U`\0`\x05U`\x03Tb\0\x16t\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0%\x02V[`\x03\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x90UV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\x08`\x80\x82\x01R\x7FRECOVERY\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x82\x90R`\0\x90`\xC0\x01b\0\x0EhV[b\0\x16\xFAb\0%\x98V[b\0\x17\x06`\0b\0%\x02V[V[`\0b\0\x18\x0C\x82`@Q\x80` \x01b\0\x17!\x90b\0+PV[`\x1F\x19\x82\x82\x03\x81\x01\x83R`\x1F\x90\x91\x01\x16`@Rb\0\x17T`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q0`$\x82\x01R`D\x81\x01\x87\x90R`d\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x81R` \x80\x83\x01\x80Q{\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x7F\xBE\x13\xF4|\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90R\x90Qb\0\x17\xD0\x93\x92\x91\x01b\x001UV[`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x90\x82\x90Rb\0\x17\xF0\x92\x91` \x01b\x0037V[`@Q` \x81\x83\x03\x03\x81R\x90`@R\x80Q\x90` \x01 b\0&)V[\x92\x91PPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\x18\x9AW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x19\x07W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x80G\x10\x15b\0\x19YW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Finsufficient balance\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x82\x15a\x08\xFC\x02\x90\x83\x90`\0\x81\x81\x81\x85\x88\x88\xF1\x93PPPP\x15\x80\x15b\0\x19\x9DW=`\0\x80>=`\0\xFD[PPPV[`\0b\0\x19\xB7\x83``\x01Q`\xA0\x01Qb\0\x17\x08V[\x90P`\0\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16;\x11b\0\x1A\"W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Fguardian is not deployed\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\x08`\x80\x82\x01R\x7FRECOVERY\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x83\x90R`\0\x90`\xC0\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x90R\x80Q` \x90\x91\x01 \x84Q\x90\x91P\x81\x14b\0\x1A\xDBW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid template id\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@Q\x7F\xAD?_\x9B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x82\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16\x90c\xAD?_\x9B\x90b\0\x1B1\x90\x88\x90`\x04\x01b\x002eV[` `@Q\x80\x83\x03\x81`\0\x87Z\xF1\x15\x80\x15b\0\x1BQW=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90b\0\x1Bw\x91\x90b\x003\x1DV[Pb\0\x1B\x92\x83\x85\x87` \x01Q\x88``\x01Q`\x80\x01Qb\0&?V[PPPPPV[b\0\x1B\xA3b\0%\x98V[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x1C\x0FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Frecovery not in progress\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[B`\x05T\x11b\0\x1CbW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Ftimelock expired\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90U`\x03\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x90U`\0`\x05UV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\x1DAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x1D\xAEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0\x1E\x13W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16`\0\x90\x81R`\x04` R`@\x81 T`\xFF\x16`\x02\x81\x11\x15b\0\x1EPWb\0\x1EPb\0.\xFEV[\x14b\0\x1E\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Fguardian status must be NONE\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x90\x81R`\x04` R`@\x90 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90UV[b\0\x1E\xF8b\0%\x98V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0\x1FJW`@Q\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0`\x04\x82\x01R`$\x01b\0\x02IV[b\0\x0E\x18\x81b\0%\x02V[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0\x80Th\x01\0\0\0\0\0\0\0\0\x81\x04`\xFF\x16\x15\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x81\x15\x80\x15b\0\x1F\xA1WP\x82[\x90P`\0\x82g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\x01\x14\x80\x15b\0\x1F\xBFWP0;\x15[\x90P\x81\x15\x80\x15b\0\x1F\xCEWP\x80\x15[\x15b\0 \x06W`@Q\x7F\xF9.\xE8\xA9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\x16`\x01\x17\x85U\x83\x15b\0 hW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16h\x01\0\0\0\0\0\0\0\0\x17\x85U[b\0 s\x89b\0*\x9FV[`\x02\x80T`\0\x80Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x8D\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x92\x83\x16\x17\x90\x92U`\x01\x80T\x8C\x84\x16\x92\x16\x91\x90\x91\x17\x90U\x88\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x17\x90U\x83\x15b\0!UW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x85U`@Q`\x01\x81R\x7F\xC7\xF5\x05\xB2\xF3q\xAE!u\xEEI\x13\xF4I\x9E\x1F&3\xA7\xB5\x93c!\xEE\xD1\xCD\xAE\xB6\x11Q\x81\xD2\x90` \x01`@Q\x80\x91\x03\x90\xA1[PPPPPPPPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0!\xE8W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\"UW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16b\0\"\xBAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x01s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\0\x90\x81R`\x04` R`@\x90 T`\xFF\x16`\x02\x81\x11\x15b\0\"\xF9Wb\0\"\xF9b\0.\xFEV[\x14b\0#nW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`!`$\x82\x01R\x7Fguardian status must be REQUESTE`D\x82\x01R\x7FD\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`d\x82\x01R`\x84\x01b\0\x02IV[\x82\x15b\0#\xBEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid template index\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x81Q`\x01\x14b\0$\x11W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid subject params\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x82`\0\x81Q\x81\x10b\0$)Wb\0$)b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0$F\x91\x90b\x003jV[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x160\x14b\0$\xAFW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1F`$\x82\x01R\x7Finvalid wallet address in email\0`D\x82\x01R`d\x01b\0\x02IV[PPPPs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x90\x81R`\x04` R`@\x90 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x02\x17\x90UV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x81\x16\x91\x82\x17\x84U`@Q\x92\x16\x91\x82\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90`\0\x90\xA3PPPV[3b\0%\xD8\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14b\0\x17\x06W`@Q\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R3`\x04\x82\x01R`$\x01b\0\x02IV[`\0b\0&8\x83\x830b\0*\xB4V[\x93\x92PPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0&\xC7W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0'4W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16b\0'\x99W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\0\x90\x81R`\x04` R`@\x90 T`\xFF\x16`\x02\x81\x11\x15b\0'\xD8Wb\0'\xD8b\0.\xFEV[\x14b\0('W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01\x81\x90R`$\x82\x01R\x7Fguardian status must be ACCEPTED`D\x82\x01R`d\x01b\0\x02IV[\x82\x15b\0(wW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid template index\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x81Q`\x02\x14b\0(\xCAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid subject params\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x82`\0\x81Q\x81\x10b\0(\xE2Wb\0(\xE2b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0(\xFF\x91\x90b\x003jV[\x90P`\0\x83`\x01\x81Q\x81\x10b\0)\x19Wb\0)\x19b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0)6\x91\x90b\x003jV[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x160\x14b\0)\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Finvalid guardian in email\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0*\x04W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x12`$\x82\x01R\x7Finvalid new signer\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90U`\x03\x80Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x17\x90Ub\0*\x94b\x03\xF4\x80Bb\x003\x8AV[`\x05UPPPPPPV[b\0*\xA9b\0*\xDEV[b\0\x0E\x18\x81b\0+FV[`\0`@Q\x83`@\x82\x01R\x84` \x82\x01R\x82\x81R`\x0B\x81\x01\x90P`\xFF\x81S`U\x90 \x94\x93PPPPV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0Th\x01\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x17\x06W`@Q\x7F\xD7\xE6\xBC\xF8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[b\0\x1E\xF8b\0*\xDEV[a\x04\x17\x80b\x003\xC6\x839\x01\x90V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`A`\x04R`$`\0\xFD[`@Qa\x01\0\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0+\xB4Wb\0+\xB4b\0+^V[`@R\x90V[`@Q`\x80\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0+\xB4Wb\0+\xB4b\0+^V[`@Q`\x1F\x82\x01`\x1F\x19\x16\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0,\x0CWb\0,\x0Cb\0+^V[`@R\x91\x90PV[`\0\x82`\x1F\x83\x01\x12b\0,&W`\0\x80\xFD[\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15b\0,CWb\0,Cb\0+^V[b\0,X` `\x1F\x19`\x1F\x84\x01\x16\x01b\0+\xE0V[\x81\x81R\x84` \x83\x86\x01\x01\x11\x15b\0,nW`\0\x80\xFD[\x81` \x85\x01` \x83\x017`\0\x91\x81\x01` \x01\x91\x90\x91R\x93\x92PPPV[\x805\x80\x15\x15\x81\x14b\0,\x9CW`\0\x80\xFD[\x91\x90PV[`\0a\x01\0\x82\x84\x03\x12\x15b\0,\xB5W`\0\x80\xFD[b\0,\xBFb\0+\x8DV[\x90P\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15b\0,\xDAW`\0\x80\xFD[b\0,\xE8\x85\x83\x86\x01b\0,\x14V[\x83R` \x84\x015` \x84\x01R`@\x84\x015`@\x84\x01R``\x84\x015\x91P\x80\x82\x11\x15b\0-\x13W`\0\x80\xFD[b\0-!\x85\x83\x86\x01b\0,\x14V[``\x84\x01R`\x80\x84\x015`\x80\x84\x01R`\xA0\x84\x015`\xA0\x84\x01Rb\0-H`\xC0\x85\x01b\0,\x8BV[`\xC0\x84\x01R`\xE0\x84\x015\x91P\x80\x82\x11\x15b\0-bW`\0\x80\xFD[Pb\0-q\x84\x82\x85\x01b\0,\x14V[`\xE0\x83\x01RP\x92\x91PPV[`\0\x80`@\x83\x85\x03\x12\x15b\0-\x91W`\0\x80\xFD[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15b\0-\xAAW`\0\x80\xFD[\x90\x84\x01\x90`\x80\x82\x87\x03\x12\x15b\0-\xBFW`\0\x80\xFD[b\0-\xC9b\0+\xBAV[\x825\x81R` \x80\x84\x015\x83\x81\x11\x15b\0-\xE1W`\0\x80\xFD[\x84\x01`\x1F\x81\x01\x89\x13b\0-\xF3W`\0\x80\xFD[\x805\x84\x81\x11\x15b\0.\x08Wb\0.\x08b\0+^V[\x80`\x05\x1Bb\0.\x19\x84\x82\x01b\0+\xE0V[\x91\x82R\x82\x81\x01\x84\x01\x91\x84\x81\x01\x90\x8C\x84\x11\x15b\0.4W`\0\x80\xFD[\x85\x85\x01\x92P[\x83\x83\x10\x15b\0.uW\x825\x88\x81\x11\x15b\0.TW`\0\x80\x81\xFD[b\0.d\x8E\x88\x83\x89\x01\x01b\0,\x14V[\x83RP\x91\x85\x01\x91\x90\x85\x01\x90b\0.:V[\x86\x86\x01RPPPP`@\x84\x81\x015\x90\x83\x01R``\x84\x015\x83\x81\x11\x15b\0.\x9AW`\0\x80\xFD[b\0.\xA8\x89\x82\x87\x01b\0,\xA1V[``\x84\x01RP\x90\x97\x95\x015\x95PPPPPV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x14b\0\x0E\x18W`\0\x80\xFD[`\0` \x82\x84\x03\x12\x15b\0.\xF1W`\0\x80\xFD[\x815b\0&8\x81b\0.\xBBV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`!`\x04R`$`\0\xFD[` \x81\x01`\x03\x83\x10b\0/iW\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`!`\x04R`$`\0\xFD[\x91\x90R\x90V[`\0` \x82\x84\x03\x12\x15b\0/\x82W`\0\x80\xFD[P5\x91\x90PV[`\0[\x83\x81\x10\x15b\0/\xA6W\x81\x81\x01Q\x83\x82\x01R` \x01b\0/\x8CV[PP`\0\x91\x01RV[`\0\x81Q\x80\x84Rb\0/\xC9\x81` \x86\x01` \x86\x01b\0/\x89V[`\x1F\x01`\x1F\x19\x16\x92\x90\x92\x01` \x01\x92\x91PPV[`\0\x82\x82Q\x80\x85R` \x80\x86\x01\x95P` \x82`\x05\x1B\x84\x01\x01` \x86\x01`\0[\x84\x81\x10\x15b\x000.W`\x1F\x19\x86\x84\x03\x01\x89Rb\x000\x1B\x83\x83Qb\0/\xAFV[\x98\x84\x01\x98\x92P\x90\x83\x01\x90`\x01\x01b\0/\xFCV[P\x90\x97\x96PPPPPPPV[`\0` \x80\x83\x01` \x84R\x80\x85Q\x80\x83R`@\x86\x01\x91P`@\x81`\x05\x1B\x87\x01\x01\x92P` \x87\x01`\0[\x82\x81\x10\x15b\x000\xB4W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC0\x88\x86\x03\x01\x84Rb\x000\xA1\x85\x83Qb\0/\xDDV[\x94P\x92\x85\x01\x92\x90\x85\x01\x90`\x01\x01b\x000dV[P\x92\x97\x96PPPPPPPV[`\0\x80`@\x83\x85\x03\x12\x15b\x000\xD5W`\0\x80\xFD[\x825b\x000\xE2\x81b\0.\xBBV[\x94` \x93\x90\x93\x015\x93PPPV[`\0\x80`\0\x80`\x80\x85\x87\x03\x12\x15b\x001\x07W`\0\x80\xFD[\x845b\x001\x14\x81b\0.\xBBV[\x93P` \x85\x015b\x001&\x81b\0.\xBBV[\x92P`@\x85\x015b\x0018\x81b\0.\xBBV[\x91P``\x85\x015b\x001J\x81b\0.\xBBV[\x93\x96\x92\x95P\x90\x93PPV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x81R`@` \x82\x01R`\0b\x001\x86`@\x83\x01\x84b\0/\xAFV[\x94\x93PPPPV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`2`\x04R`$`\0\xFD[\x82\x81R`@` \x82\x01R`\0b\x001\x86`@\x83\x01\x84b\0/\xDDV[`\0a\x01\0\x82Q\x81\x85Rb\x001\xF0\x82\x86\x01\x82b\0/\xAFV[\x91PP` \x83\x01Q` \x85\x01R`@\x83\x01Q`@\x85\x01R``\x83\x01Q\x84\x82\x03``\x86\x01Rb\x002 \x82\x82b\0/\xAFV[\x91PP`\x80\x83\x01Q`\x80\x85\x01R`\xA0\x83\x01Q`\xA0\x85\x01R`\xC0\x83\x01Q\x15\x15`\xC0\x85\x01R`\xE0\x83\x01Q\x84\x82\x03`\xE0\x86\x01Rb\x002\\\x82\x82b\0/\xAFV[\x95\x94PPPPPV[`\0` \x80\x83R`\xA0\x83\x01\x84Q\x82\x85\x01R\x81\x85\x01Q`\x80`@\x86\x01R\x81\x81Q\x80\x84R`\xC0\x87\x01\x91P`\xC0\x81`\x05\x1B\x88\x01\x01\x93P\x84\x83\x01\x92P`\0[\x81\x81\x10\x15b\x002\xF0W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF@\x88\x86\x03\x01\x83Rb\x002\xDD\x85\x85Qb\0/\xAFV[\x94P\x92\x85\x01\x92\x91\x85\x01\x91`\x01\x01b\x002\xA0V[PPPP`@\x85\x01Q``\x85\x01R``\x85\x01Q\x91P`\x1F\x19\x84\x82\x03\x01`\x80\x85\x01Rb\x002\\\x81\x83b\x001\xD8V[`\0` \x82\x84\x03\x12\x15b\x0030W`\0\x80\xFD[PQ\x91\x90PV[`\0\x83Qb\x003K\x81\x84` \x88\x01b\0/\x89V[\x83Q\x90\x83\x01\x90b\x003a\x81\x83` \x88\x01b\0/\x89V[\x01\x94\x93PPPPV[`\0` \x82\x84\x03\x12\x15b\x003}W`\0\x80\xFD[\x81Qb\0&8\x81b\0.\xBBV[\x80\x82\x01\x80\x82\x11\x15b\0\x18\x0CW\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\x11`\x04R`$`\0\xFD\xFE`\x80`@R`@Qa\x04\x178\x03\x80a\x04\x17\x839\x81\x01`@\x81\x90Ra\0\"\x91a\x02hV[a\0,\x82\x82a\x003V[PPa\x03RV[a\0<\x82a\0\x92V[`@Q`\x01`\x01`\xA0\x1B\x03\x83\x16\x90\x7F\xBC|\xD7Z \xEE'\xFD\x9A\xDE\xBA\xB3 A\xF7U!M\xBCk\xFF\xA9\x0C\xC0\"[9\xDA.\\-;\x90`\0\x90\xA2\x80Q\x15a\0\x86Wa\0\x81\x82\x82a\x01\x0EV[PPPV[a\0\x8Ea\x01\x85V[PPV[\x80`\x01`\x01`\xA0\x1B\x03\x16;`\0\x03a\0\xCDW`@QcL\x9C\x8C\xE3`\xE0\x1B\x81R`\x01`\x01`\xA0\x1B\x03\x82\x16`\x04\x82\x01R`$\x01[`@Q\x80\x91\x03\x90\xFD[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x80T`\x01`\x01`\xA0\x1B\x03\x19\x16`\x01`\x01`\xA0\x1B\x03\x92\x90\x92\x16\x91\x90\x91\x17\x90UV[```\0\x80\x84`\x01`\x01`\xA0\x1B\x03\x16\x84`@Qa\x01+\x91\x90a\x036V[`\0`@Q\x80\x83\x03\x81\x85Z\xF4\x91PP=\x80`\0\x81\x14a\x01fW`@Q\x91P`\x1F\x19`?=\x01\x16\x82\x01`@R=\x82R=`\0` \x84\x01>a\x01kV[``\x91P[P\x90\x92P\x90Pa\x01|\x85\x83\x83a\x01\xA6V[\x95\x94PPPPPV[4\x15a\x01\xA4W`@Qc\xB3\x98\x97\x9F`\xE0\x1B\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[V[``\x82a\x01\xBBWa\x01\xB6\x82a\x02\x05V[a\x01\xFEV[\x81Q\x15\x80\x15a\x01\xD2WP`\x01`\x01`\xA0\x1B\x03\x84\x16;\x15[\x15a\x01\xFBW`@Qc\x99\x96\xB3\x15`\xE0\x1B\x81R`\x01`\x01`\xA0\x1B\x03\x85\x16`\x04\x82\x01R`$\x01a\0\xC4V[P\x80[\x93\x92PPPV[\x80Q\x15a\x02\x15W\x80Q\x80\x82` \x01\xFD[`@Qc\n\x12\xF5!`\xE1\x1B\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[cNH{q`\xE0\x1B`\0R`A`\x04R`$`\0\xFD[`\0[\x83\x81\x10\x15a\x02_W\x81\x81\x01Q\x83\x82\x01R` \x01a\x02GV[PP`\0\x91\x01RV[`\0\x80`@\x83\x85\x03\x12\x15a\x02{W`\0\x80\xFD[\x82Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x81\x14a\x02\x92W`\0\x80\xFD[` \x84\x01Q\x90\x92P`\x01`\x01`@\x1B\x03\x80\x82\x11\x15a\x02\xAFW`\0\x80\xFD[\x81\x85\x01\x91P\x85`\x1F\x83\x01\x12a\x02\xC3W`\0\x80\xFD[\x81Q\x81\x81\x11\x15a\x02\xD5Wa\x02\xD5a\x02.V[`@Q`\x1F\x82\x01`\x1F\x19\x90\x81\x16`?\x01\x16\x81\x01\x90\x83\x82\x11\x81\x83\x10\x17\x15a\x02\xFDWa\x02\xFDa\x02.V[\x81`@R\x82\x81R\x88` \x84\x87\x01\x01\x11\x15a\x03\x16W`\0\x80\xFD[a\x03'\x83` \x83\x01` \x88\x01a\x02DV[\x80\x95PPPPPP\x92P\x92\x90PV[`\0\x82Qa\x03H\x81\x84` \x87\x01a\x02DV[\x91\x90\x91\x01\x92\x91PPV[`\xB7\x80a\x03``\09`\0\xF3\xFE`\x80`@R`\n`\x0CV[\0[`\x18`\x14`\x1AV[`^V[V[`\0`Y\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBCTs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[\x90P\x90V[6`\0\x807`\0\x806`\0\x84Z\xF4=`\0\x80>\x80\x80\x15`|W=`\0\xF3[=`\0\xFD\xFE\xA2dipfsX\"\x12 \xE5\xD4\xE8\x85\xAEN\x1DE\x8A3oD\xA5F\xC7\x08\xCB\xFA\x1B\xFA\xE5d\\\xBE\xB0\xFF\xF8\x0C\xAAL\xDD\x1CdsolcC\0\x08\x17\x003\xA2dipfsX\"\x12 \xB0&\xBB@\xBE\x91\x08\x9F\x168\x8F\x11\xE5_\x8Be\x8E\n\xD7\x90\xE1\xEDTL\xCA\x83\xCE#r\xD96\xC6dsolcC\0\x08\x17\x003";
    /// The bytecode of the contract.
    pub static SIMPLEWALLET_BYTECODE: ::ethers::core::types::Bytes = ::ethers::core::types::Bytes::from_static(
        __BYTECODE,
    );
    #[rustfmt::skip]
    const __DEPLOYED_BYTECODE: &[u8] = b"`\x80`@R`\x046\x10b\0\x01\xDBW`\x005`\xE0\x1C\x80cqP\x18\xA6\x11b\0\x01\x03W\x80c\xB6 \x16\x92\x11b\0\0\x97W\x80c\xD4F\xBB\x9A\x11b\0\0mW\x80c\xD4F\xBB\x9A\x14b\0\x06\xB9W\x80c\xDB\xEB\x88*\x14b\0\x06\xD1W\x80c\xF2\xFD\xE3\x8B\x14b\0\x06\xF6W\x80c\xF8\xC8v^\x14b\0\x07\x1BWb\0\x02TV[\x80c\xB6 \x16\x92\x14b\0\x06OW\x80c\xB6\x81&\xFA\x14b\0\x06|W\x80c\xD32\x19\xB4\x14b\0\x06\xA1Wb\0\x02TV[\x80c\x81R\x07\x82\x11b\0\0\xD9W\x80c\x81R\x07\x82\x14b\0\x05tW\x80c\x8D\xA5\xCB[\x14b\0\x05\x99W\x80c\x91\xAC'\x88\x14b\0\x05\xE5W\x80c\xA9\x05\x9C\xBB\x14b\0\x06*Wb\0\x02TV[\x80cqP\x18\xA6\x14b\0\x04\xFEW\x80cq\xCE`d\x14b\0\x05\x16W\x80cs5\x7F\x85\x14b\0\x05EWb\0\x02TV[\x80c>\x91\xCD\xCD\x11b\0\x01{W\x80c[\xAF\xAD\xDA\x11b\0\x01QW\x80c[\xAF\xAD\xDA\x14b\0\x04zW\x80cf>\xA2\xE2\x14b\0\x04\x92W\x80ck\x0Cq~\x14b\0\x04\xC1W\x80cm\xA9\x95\x15\x14b\0\x04\xD9Wb\0\x02TV[\x80c>\x91\xCD\xCD\x14b\0\x04\rW\x80c@\n\xD5\xCE\x14b\0\x044W\x80cJ[\xCB\xF8\x14b\0\x04aWb\0\x02TV[\x80c+z\xC3\xF3\x11b\0\x01\xB1W\x80c+z\xC3\xF3\x14b\0\x03\x87W\x80c.\x1A}M\x14b\0\x03\xB4W\x80c2\xCC\xC2\xF2\x14b\0\x03\xD9Wb\0\x02TV[\x80c\x04\x81\xAFg\x14b\0\x02\xC1W\x80c\x063\xB1J\x14b\0\x02\xE6W\x80c\x10\x98\xE0.\x14b\0\x032Wb\0\x02TV[6b\0\x02TW`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x02RW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01[`@Q\x80\x91\x03\x90\xFD[\0[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x02RW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[4\x80\x15b\0\x02\xCEW`\0\x80\xFD[Pb\0\x02Rb\0\x02\xE06`\x04b\0-}V[b\0\x07@V[4\x80\x15b\0\x02\xF3W`\0\x80\xFD[Pb\0\x03\x1Ab\0\x03\x056`\x04b\0.\xDEV[`\x04` R`\0\x90\x81R`@\x90 T`\xFF\x16\x81V[`@Qb\0\x03)\x91\x90b\0/-V[`@Q\x80\x91\x03\x90\xF3[4\x80\x15b\0\x03?W`\0\x80\xFD[P`\x02Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16\x81R` \x01b\0\x03)V[4\x80\x15b\0\x03\x94W`\0\x80\xFD[P`\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x03\xC1W`\0\x80\xFD[Pb\0\x02Rb\0\x03\xD36`\x04b\0/oV[b\0\r\x17V[4\x80\x15b\0\x03\xE6W`\0\x80\xFD[Pb\0\x03\xFEb\0\x03\xF86`\x04b\0/oV[b\0\x0E\x1BV[`@Q\x90\x81R` \x01b\0\x03)V[4\x80\x15b\0\x04\x1AW`\0\x80\xFD[Pb\0\x04%b\0\x0E\x86V[`@Qb\0\x03)\x91\x90b\x000;V[4\x80\x15b\0\x04AW`\0\x80\xFD[P`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x04nW`\0\x80\xFD[Pb\0\x03\xFEb\x03\xF4\x80\x81V[4\x80\x15b\0\x04\x87W`\0\x80\xFD[Pb\0\x04%b\0\x12\xABV[4\x80\x15b\0\x04\x9FW`\0\x80\xFD[P`\0Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x04\xCEW`\0\x80\xFD[Pb\0\x02Rb\0\x15cV[4\x80\x15b\0\x04\xE6W`\0\x80\xFD[Pb\0\x03\xFEb\0\x04\xF86`\x04b\0/oV[b\0\x16\x9EV[4\x80\x15b\0\x05\x0BW`\0\x80\xFD[Pb\0\x02Rb\0\x16\xF0V[4\x80\x15b\0\x05#W`\0\x80\xFD[P`\x03Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x05RW`\0\x80\xFD[P`\x01Tb\0\x03a\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x81V[4\x80\x15b\0\x05\x81W`\0\x80\xFD[Pb\0\x03ab\0\x05\x936`\x04b\0/oV[b\0\x17\x08V[4\x80\x15b\0\x05\xA6W`\0\x80\xFD[P\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x05\xF2W`\0\x80\xFD[P`\x02Tb\0\x06\x19\x90t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x81V[`@Q\x90\x15\x15\x81R` \x01b\0\x03)V[4\x80\x15b\0\x067W`\0\x80\xFD[Pb\0\x02Rb\0\x06I6`\x04b\x000\xC1V[b\0\x18\x12V[4\x80\x15b\0\x06\\W`\0\x80\xFD[P`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0\x03aV[4\x80\x15b\0\x06\x89W`\0\x80\xFD[Pb\0\x02Rb\0\x06\x9B6`\x04b\0-}V[b\0\x19\xA2V[4\x80\x15b\0\x06\xAEW`\0\x80\xFD[Pb\0\x03\xFE`\x05T\x81V[4\x80\x15b\0\x06\xC6W`\0\x80\xFD[Pb\0\x02Rb\0\x1B\x99V[4\x80\x15b\0\x06\xDEW`\0\x80\xFD[Pb\0\x02Rb\0\x06\xF06`\x04b\0.\xDEV[b\0\x1C\xB9V[4\x80\x15b\0\x07\x03W`\0\x80\xFD[Pb\0\x02Rb\0\x07\x156`\x04b\0.\xDEV[b\0\x1E\xEEV[4\x80\x15b\0\x07(W`\0\x80\xFD[Pb\0\x02Rb\0\x07:6`\x04b\x000\xF0V[b\0\x1FUV[`\0b\0\x07U\x83``\x01Q`\xA0\x01Qb\0\x17\x08V[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16;\x15b\0\x07\xBEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Fguardian is already deployed\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0b\0\x07\xCB\x83b\0\x0E\x1BV[\x84Q\x90\x91P\x81\x14b\0\x08 W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid template id\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[``\x84\x01Q`\xC0\x01Q\x15\x15`\x01\x14b\0\x08|W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7FisCodeExist is false\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x84``\x01Q`\xA0\x01Qb\0\x08\xA7`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[``\x87\x01Q`\xA0\x01Q`@Q0`$\x82\x01R`D\x81\x01\x91\x90\x91R`d\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x81R` \x82\x01\x80Q{\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x7F\xBE\x13\xF4|\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90RQb\0\t(\x90b\0+PV[b\0\t5\x92\x91\x90b\x001UV[\x81\x90`@Q\x80\x91\x03\x90`\0\xF5\x90P\x80\x15\x80\x15b\0\tVW=`\0\x80>=`\0\xFD[P\x90P\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16c\xA5\0\x12\\b\0\t\x96`\x01Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xE0\x84\x90\x1B\x16\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16`\x04\x82\x01R`$\x01`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\t\xFDW`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\n\x12W=`\0\x80>=`\0\xFD[PPPP\x80s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\x97\xFC\0|b\0\nR`\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q\x7F\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xE0\x84\x90\x1B\x16\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x90\x91\x16`\x04\x82\x01R`$\x01`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\n\xB9W`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\n\xCEW=`\0\x80>=`\0\xFD[PPPP`\0[b\0\n\xDFb\0\x12\xABV[Q\x81\x10\x15b\0\x0B\x95W\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\xC4\xB8M\xF4b\0\x0B\x0F\x83b\0\x0E\x1BV[b\0\x0B\x19b\0\x12\xABV[\x84\x81Q\x81\x10b\0\x0B-Wb\0\x0B-b\x001\x8EV[` \x02` \x01\x01Q`@Q\x83c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01b\0\x0BT\x92\x91\x90b\x001\xBDV[`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\x0BoW`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\x0B\x84W=`\0\x80>=`\0\xFD[PP`\x01\x90\x92\x01\x91Pb\0\n\xD5\x90PV[P`\0[b\0\x0B\xA3b\0\x0E\x86V[Q\x81\x10\x15b\0\x0CYW\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16c\xC4\xB8M\xF4b\0\x0B\xD3\x83b\0\x16\x9EV[b\0\x0B\xDDb\0\x0E\x86V[\x84\x81Q\x81\x10b\0\x0B\xF1Wb\0\x0B\xF1b\x001\x8EV[` \x02` \x01\x01Q`@Q\x83c\xFF\xFF\xFF\xFF\x16`\xE0\x1B\x81R`\x04\x01b\0\x0C\x18\x92\x91\x90b\x001\xBDV[`\0`@Q\x80\x83\x03\x81`\0\x87\x80;\x15\x80\x15b\0\x0C3W`\0\x80\xFD[PZ\xF1\x15\x80\x15b\0\x0CHW=`\0\x80>=`\0\xFD[PP`\x01\x90\x92\x01\x91Pb\0\x0B\x99\x90PV[P`@Q\x7F\xAD?_\x9B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81Rs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16\x90c\xAD?_\x9B\x90b\0\x0C\xAE\x90\x89\x90`\x04\x01b\x002eV[` `@Q\x80\x83\x03\x81`\0\x87Z\xF1\x15\x80\x15b\0\x0C\xCEW=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90b\0\x0C\xF4\x91\x90b\x003\x1DV[Pb\0\r\x0F\x84\x86\x88` \x01Q\x89``\x01Q`\x80\x01Qb\0!`V[PPPPPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\r\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x0E\x0CW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[b\0\x0E\x183\x82b\0\x18\x12V[PV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\n`\x80\x82\x01R\x7FACCEPTANCE\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x82\x90R`\0\x90`\xC0\x01[`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x90R\x80Q` \x90\x91\x01 \x92\x91PPV[`@\x80Q`\x01\x80\x82R\x81\x83\x01\x90\x92R``\x91`\0\x91\x90\x81` \x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x0E\xA1WPP`@\x80Q`\x08\x80\x82Ra\x01 \x82\x01\x90\x92R\x91\x92P` \x82\x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x0E\xCFW\x90PP\x81`\0\x81Q\x81\x10b\0\x0E\xFBWb\0\x0E\xFBb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7FSet\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x0FRWb\0\x0FRb\x001\x8EV[` \x02` \x01\x01Q`\0\x81Q\x81\x10b\0\x0FoWb\0\x0Fob\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Fthe\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x0F\xC6Wb\0\x0F\xC6b\x001\x8EV[` \x02` \x01\x01Q`\x01\x81Q\x81\x10b\0\x0F\xE3Wb\0\x0F\xE3b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Fnew\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x10:Wb\0\x10:b\x001\x8EV[` \x02` \x01\x01Q`\x02\x81Q\x81\x10b\0\x10WWb\0\x10Wb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x06\x81R` \x01\x7Fsigner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x10\xAEWb\0\x10\xAEb\x001\x8EV[` \x02` \x01\x01Q`\x03\x81Q\x81\x10b\0\x10\xCBWb\0\x10\xCBb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x02\x81R` \x01\x7Fof\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x11\"Wb\0\x11\"b\x001\x8EV[` \x02` \x01\x01Q`\x04\x81Q\x81\x10b\0\x11?Wb\0\x11?b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x11\x96Wb\0\x11\x96b\x001\x8EV[` \x02` \x01\x01Q`\x05\x81Q\x81\x10b\0\x11\xB3Wb\0\x11\xB3b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x02\x81R` \x01\x7Fto\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x12\nWb\0\x12\nb\x001\x8EV[` \x02` \x01\x01Q`\x06\x81Q\x81\x10b\0\x12'Wb\0\x12'b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x12~Wb\0\x12~b\x001\x8EV[` \x02` \x01\x01Q`\x07\x81Q\x81\x10b\0\x12\x9BWb\0\x12\x9Bb\x001\x8EV[` \x90\x81\x02\x91\x90\x91\x01\x01R\x91\x90PV[`@\x80Q`\x01\x80\x82R\x81\x83\x01\x90\x92R``\x91`\0\x91\x90\x81` \x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x12\xC6WPP`@\x80Q`\x05\x80\x82R`\xC0\x82\x01\x90\x92R\x91\x92P` \x82\x01[``\x81R` \x01\x90`\x01\x90\x03\x90\x81b\0\x12\xF3W\x90PP\x81`\0\x81Q\x81\x10b\0\x13\x1FWb\0\x13\x1Fb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x06\x81R` \x01\x7FAccept\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x13vWb\0\x13vb\x001\x8EV[` \x02` \x01\x01Q`\0\x81Q\x81\x10b\0\x13\x93Wb\0\x13\x93b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x08\x81R` \x01\x7Fguardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x13\xEAWb\0\x13\xEAb\x001\x8EV[` \x02` \x01\x01Q`\x01\x81Q\x81\x10b\0\x14\x07Wb\0\x14\x07b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x07\x81R` \x01\x7Frequest\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x14^Wb\0\x14^b\x001\x8EV[` \x02` \x01\x01Q`\x02\x81Q\x81\x10b\0\x14{Wb\0\x14{b\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\x03\x81R` \x01\x7Ffor\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x14\xD2Wb\0\x14\xD2b\x001\x8EV[` \x02` \x01\x01Q`\x03\x81Q\x81\x10b\0\x14\xEFWb\0\x14\xEFb\x001\x8EV[` \x02` \x01\x01\x81\x90RP`@Q\x80`@\x01`@R\x80`\t\x81R` \x01\x7F{ethAddr}\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81RP\x81`\0\x81Q\x81\x10b\0\x15FWb\0\x15Fb\x001\x8EV[` \x02` \x01\x01Q`\x04\x81Q\x81\x10b\0\x12\x9BWb\0\x12\x9Bb\x001\x8EV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x15\xCFW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Frecovery not in progress\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[B`\x05T\x11\x15b\0\x16#W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Ftimelock not expired\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90U`\0`\x05U`\x03Tb\0\x16t\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16b\0%\x02V[`\x03\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x90UV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\x08`\x80\x82\x01R\x7FRECOVERY\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x82\x90R`\0\x90`\xC0\x01b\0\x0EhV[b\0\x16\xFAb\0%\x98V[b\0\x17\x06`\0b\0%\x02V[V[`\0b\0\x18\x0C\x82`@Q\x80` \x01b\0\x17!\x90b\0+PV[`\x1F\x19\x82\x82\x03\x81\x01\x83R`\x1F\x90\x91\x01\x16`@Rb\0\x17T`\x02Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[`@Q0`$\x82\x01R`D\x81\x01\x87\x90R`d\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x81R` \x80\x83\x01\x80Q{\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x7F\xBE\x13\xF4|\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90R\x90Qb\0\x17\xD0\x93\x92\x91\x01b\x001UV[`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x90\x82\x90Rb\0\x17\xF0\x92\x91` \x01b\x0037V[`@Q` \x81\x83\x03\x03\x81R\x90`@R\x80Q\x90` \x01 b\0&)V[\x92\x91PPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\x18\x9AW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x19\x07W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x80G\x10\x15b\0\x19YW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Finsufficient balance\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@Qs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x90\x82\x15a\x08\xFC\x02\x90\x83\x90`\0\x81\x81\x81\x85\x88\x88\xF1\x93PPPP\x15\x80\x15b\0\x19\x9DW=`\0\x80>=`\0\xFD[PPPV[`\0b\0\x19\xB7\x83``\x01Q`\xA0\x01Qb\0\x17\x08V[\x90P`\0\x81s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16;\x11b\0\x1A\"W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Fguardian is not deployed\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@\x80Q`\x01` \x82\x01R``\x91\x81\x01\x82\x90R`\x08`\x80\x82\x01R\x7FRECOVERY\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\xA0\x82\x01R\x90\x81\x01\x83\x90R`\0\x90`\xC0\x01`@\x80Q`\x1F\x19\x81\x84\x03\x01\x81R\x91\x90R\x80Q` \x90\x91\x01 \x84Q\x90\x91P\x81\x14b\0\x1A\xDBW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x13`$\x82\x01R\x7Finvalid template id\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`@Q\x7F\xAD?_\x9B\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R\x82\x90s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x16\x90c\xAD?_\x9B\x90b\0\x1B1\x90\x88\x90`\x04\x01b\x002eV[` `@Q\x80\x83\x03\x81`\0\x87Z\xF1\x15\x80\x15b\0\x1BQW=`\0\x80>=`\0\xFD[PPPP`@Q=`\x1F\x19`\x1F\x82\x01\x16\x82\x01\x80`@RP\x81\x01\x90b\0\x1Bw\x91\x90b\x003\x1DV[Pb\0\x1B\x92\x83\x85\x87` \x01Q\x88``\x01Q`\x80\x01Qb\0&?V[PPPPPV[b\0\x1B\xA3b\0%\x98V[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x1C\x0FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x18`$\x82\x01R\x7Frecovery not in progress\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[B`\x05T\x11b\0\x1CbW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Ftimelock expired\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90U`\x03\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x16\x90U`\0`\x05UV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0\x1DAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\x1D\xAEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0\x1E\x13W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16`\0\x90\x81R`\x04` R`@\x81 T`\xFF\x16`\x02\x81\x11\x15b\0\x1EPWb\0\x1EPb\0.\xFEV[\x14b\0\x1E\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1C`$\x82\x01R\x7Fguardian status must be NONE\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x90\x81R`\x04` R`@\x90 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x01\x17\x90UV[b\0\x1E\xF8b\0%\x98V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0\x1FJW`@Q\x7F\x1EO\xBD\xF7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\0`\x04\x82\x01R`$\x01b\0\x02IV[b\0\x0E\x18\x81b\0%\x02V[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0\x80Th\x01\0\0\0\0\0\0\0\0\x81\x04`\xFF\x16\x15\x90g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x81\x15\x80\x15b\0\x1F\xA1WP\x82[\x90P`\0\x82g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\x01\x14\x80\x15b\0\x1F\xBFWP0;\x15[\x90P\x81\x15\x80\x15b\0\x1F\xCEWP\x80\x15[\x15b\0 \x06W`@Q\x7F\xF9.\xE8\xA9\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\x16`\x01\x17\x85U\x83\x15b\0 hW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16h\x01\0\0\0\0\0\0\0\0\x17\x85U[b\0 s\x89b\0*\x9FV[`\x02\x80T`\0\x80Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x8D\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x92\x83\x16\x17\x90\x92U`\x01\x80T\x8C\x84\x16\x92\x16\x91\x90\x91\x17\x90U\x88\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x17\x90U\x83\x15b\0!UW\x84T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x85U`@Q`\x01\x81R\x7F\xC7\xF5\x05\xB2\xF3q\xAE!u\xEEI\x13\xF4I\x9E\x1F&3\xA7\xB5\x93c!\xEE\xD1\xCD\xAE\xB6\x11Q\x81\xD2\x90` \x01`@Q\x80\x91\x03\x90\xA1[PPPPPPPPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0!\xE8W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0\"UW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16b\0\"\xBAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x01s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\0\x90\x81R`\x04` R`@\x90 T`\xFF\x16`\x02\x81\x11\x15b\0\"\xF9Wb\0\"\xF9b\0.\xFEV[\x14b\0#nW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`!`$\x82\x01R\x7Fguardian status must be REQUESTE`D\x82\x01R\x7FD\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`d\x82\x01R`\x84\x01b\0\x02IV[\x82\x15b\0#\xBEW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid template index\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x81Q`\x01\x14b\0$\x11W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid subject params\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x82`\0\x81Q\x81\x10b\0$)Wb\0$)b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0$F\x91\x90b\x003jV[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x160\x14b\0$\xAFW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x1F`$\x82\x01R\x7Finvalid wallet address in email\0`D\x82\x01R`d\x01b\0\x02IV[PPPPs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16`\0\x90\x81R`\x04` R`@\x90 \x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\x16`\x02\x17\x90UV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81\x16s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x81\x16\x91\x82\x17\x84U`@Q\x92\x16\x91\x82\x90\x7F\x8B\xE0\x07\x9CS\x16Y\x14\x13D\xCD\x1F\xD0\xA4\xF2\x84\x19I\x7F\x97\"\xA3\xDA\xAF\xE3\xB4\x18okdW\xE0\x90`\0\x90\xA3PPPV[3b\0%\xD8\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x14b\0\x17\x06W`@Q\x7F\x11\x8C\xDA\xA7\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R3`\x04\x82\x01R`$\x01b\0\x02IV[`\0b\0&8\x83\x830b\0*\xB4V[\x93\x92PPPV[\x7F\x90\x16\xD0\x9Dr\xD4\x0F\xDA\xE2\xFD\x8C\xEA\xC6\xB6#Lw\x06!O\xD3\x9C\x1C\xD1\xE6\t\xA0R\x8C\x19\x93\0Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x163\x14b\0&\xC7W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\n`$\x82\x01R\x7Fonly owner\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02Tt\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16\x15b\0'4W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x14`$\x82\x01R\x7Frecovery in progress\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x84\x16b\0'\x99W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x10`$\x82\x01R\x7Finvalid guardian\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x85\x16`\0\x90\x81R`\x04` R`@\x90 T`\xFF\x16`\x02\x81\x11\x15b\0'\xD8Wb\0'\xD8b\0.\xFEV[\x14b\0('W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01\x81\x90R`$\x82\x01R\x7Fguardian status must be ACCEPTED`D\x82\x01R`d\x01b\0\x02IV[\x82\x15b\0(wW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid template index\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[\x81Q`\x02\x14b\0(\xCAW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x16`$\x82\x01R\x7Finvalid subject params\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\0\x82`\0\x81Q\x81\x10b\0(\xE2Wb\0(\xE2b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0(\xFF\x91\x90b\x003jV[\x90P`\0\x83`\x01\x81Q\x81\x10b\0)\x19Wb\0)\x19b\x001\x8EV[` \x02` \x01\x01Q\x80` \x01\x90Q\x81\x01\x90b\0)6\x91\x90b\x003jV[\x90Ps\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x82\x160\x14b\0)\x9FW`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x19`$\x82\x01R\x7Finvalid guardian in email\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16b\0*\x04W`@QbF\x1B\xCD`\xE5\x1B\x81R` `\x04\x82\x01R`\x12`$\x82\x01R\x7Finvalid new signer\0\0\0\0\0\0\0\0\0\0\0\0\0\0`D\x82\x01R`d\x01b\0\x02IV[`\x02\x80T\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16t\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x17\x90U`\x03\x80Ts\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x90\x91\x16\x17\x90Ub\0*\x94b\x03\xF4\x80Bb\x003\x8AV[`\x05UPPPPPPV[b\0*\xA9b\0*\xDEV[b\0\x0E\x18\x81b\0+FV[`\0`@Q\x83`@\x82\x01R\x84` \x82\x01R\x82\x81R`\x0B\x81\x01\x90P`\xFF\x81S`U\x90 \x94\x93PPPPV[\x7F\xF0\xC5~\x16\x84\r\xF0@\xF1P\x88\xDC/\x81\xFE9\x1C9#\xBE\xC7>#\xA9f.\xFC\x9C\"\x9Cj\0Th\x01\0\0\0\0\0\0\0\0\x90\x04`\xFF\x16b\0\x17\x06W`@Q\x7F\xD7\xE6\xBC\xF8\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[b\0\x1E\xF8b\0*\xDEV[a\x04\x17\x80b\x003\xC6\x839\x01\x90V[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`A`\x04R`$`\0\xFD[`@Qa\x01\0\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0+\xB4Wb\0+\xB4b\0+^V[`@R\x90V[`@Q`\x80\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0+\xB4Wb\0+\xB4b\0+^V[`@Q`\x1F\x82\x01`\x1F\x19\x16\x81\x01g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x82\x82\x10\x17\x15b\0,\x0CWb\0,\x0Cb\0+^V[`@R\x91\x90PV[`\0\x82`\x1F\x83\x01\x12b\0,&W`\0\x80\xFD[\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x11\x15b\0,CWb\0,Cb\0+^V[b\0,X` `\x1F\x19`\x1F\x84\x01\x16\x01b\0+\xE0V[\x81\x81R\x84` \x83\x86\x01\x01\x11\x15b\0,nW`\0\x80\xFD[\x81` \x85\x01` \x83\x017`\0\x91\x81\x01` \x01\x91\x90\x91R\x93\x92PPPV[\x805\x80\x15\x15\x81\x14b\0,\x9CW`\0\x80\xFD[\x91\x90PV[`\0a\x01\0\x82\x84\x03\x12\x15b\0,\xB5W`\0\x80\xFD[b\0,\xBFb\0+\x8DV[\x90P\x815g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15b\0,\xDAW`\0\x80\xFD[b\0,\xE8\x85\x83\x86\x01b\0,\x14V[\x83R` \x84\x015` \x84\x01R`@\x84\x015`@\x84\x01R``\x84\x015\x91P\x80\x82\x11\x15b\0-\x13W`\0\x80\xFD[b\0-!\x85\x83\x86\x01b\0,\x14V[``\x84\x01R`\x80\x84\x015`\x80\x84\x01R`\xA0\x84\x015`\xA0\x84\x01Rb\0-H`\xC0\x85\x01b\0,\x8BV[`\xC0\x84\x01R`\xE0\x84\x015\x91P\x80\x82\x11\x15b\0-bW`\0\x80\xFD[Pb\0-q\x84\x82\x85\x01b\0,\x14V[`\xE0\x83\x01RP\x92\x91PPV[`\0\x80`@\x83\x85\x03\x12\x15b\0-\x91W`\0\x80\xFD[\x825g\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x80\x82\x11\x15b\0-\xAAW`\0\x80\xFD[\x90\x84\x01\x90`\x80\x82\x87\x03\x12\x15b\0-\xBFW`\0\x80\xFD[b\0-\xC9b\0+\xBAV[\x825\x81R` \x80\x84\x015\x83\x81\x11\x15b\0-\xE1W`\0\x80\xFD[\x84\x01`\x1F\x81\x01\x89\x13b\0-\xF3W`\0\x80\xFD[\x805\x84\x81\x11\x15b\0.\x08Wb\0.\x08b\0+^V[\x80`\x05\x1Bb\0.\x19\x84\x82\x01b\0+\xE0V[\x91\x82R\x82\x81\x01\x84\x01\x91\x84\x81\x01\x90\x8C\x84\x11\x15b\0.4W`\0\x80\xFD[\x85\x85\x01\x92P[\x83\x83\x10\x15b\0.uW\x825\x88\x81\x11\x15b\0.TW`\0\x80\x81\xFD[b\0.d\x8E\x88\x83\x89\x01\x01b\0,\x14V[\x83RP\x91\x85\x01\x91\x90\x85\x01\x90b\0.:V[\x86\x86\x01RPPPP`@\x84\x81\x015\x90\x83\x01R``\x84\x015\x83\x81\x11\x15b\0.\x9AW`\0\x80\xFD[b\0.\xA8\x89\x82\x87\x01b\0,\xA1V[``\x84\x01RP\x90\x97\x95\x015\x95PPPPPV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x81\x16\x81\x14b\0\x0E\x18W`\0\x80\xFD[`\0` \x82\x84\x03\x12\x15b\0.\xF1W`\0\x80\xFD[\x815b\0&8\x81b\0.\xBBV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`!`\x04R`$`\0\xFD[` \x81\x01`\x03\x83\x10b\0/iW\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`!`\x04R`$`\0\xFD[\x91\x90R\x90V[`\0` \x82\x84\x03\x12\x15b\0/\x82W`\0\x80\xFD[P5\x91\x90PV[`\0[\x83\x81\x10\x15b\0/\xA6W\x81\x81\x01Q\x83\x82\x01R` \x01b\0/\x8CV[PP`\0\x91\x01RV[`\0\x81Q\x80\x84Rb\0/\xC9\x81` \x86\x01` \x86\x01b\0/\x89V[`\x1F\x01`\x1F\x19\x16\x92\x90\x92\x01` \x01\x92\x91PPV[`\0\x82\x82Q\x80\x85R` \x80\x86\x01\x95P` \x82`\x05\x1B\x84\x01\x01` \x86\x01`\0[\x84\x81\x10\x15b\x000.W`\x1F\x19\x86\x84\x03\x01\x89Rb\x000\x1B\x83\x83Qb\0/\xAFV[\x98\x84\x01\x98\x92P\x90\x83\x01\x90`\x01\x01b\0/\xFCV[P\x90\x97\x96PPPPPPPV[`\0` \x80\x83\x01` \x84R\x80\x85Q\x80\x83R`@\x86\x01\x91P`@\x81`\x05\x1B\x87\x01\x01\x92P` \x87\x01`\0[\x82\x81\x10\x15b\x000\xB4W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xC0\x88\x86\x03\x01\x84Rb\x000\xA1\x85\x83Qb\0/\xDDV[\x94P\x92\x85\x01\x92\x90\x85\x01\x90`\x01\x01b\x000dV[P\x92\x97\x96PPPPPPPV[`\0\x80`@\x83\x85\x03\x12\x15b\x000\xD5W`\0\x80\xFD[\x825b\x000\xE2\x81b\0.\xBBV[\x94` \x93\x90\x93\x015\x93PPPV[`\0\x80`\0\x80`\x80\x85\x87\x03\x12\x15b\x001\x07W`\0\x80\xFD[\x845b\x001\x14\x81b\0.\xBBV[\x93P` \x85\x015b\x001&\x81b\0.\xBBV[\x92P`@\x85\x015b\x0018\x81b\0.\xBBV[\x91P``\x85\x015b\x001J\x81b\0.\xBBV[\x93\x96\x92\x95P\x90\x93PPV[s\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x83\x16\x81R`@` \x82\x01R`\0b\x001\x86`@\x83\x01\x84b\0/\xAFV[\x94\x93PPPPV[\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`2`\x04R`$`\0\xFD[\x82\x81R`@` \x82\x01R`\0b\x001\x86`@\x83\x01\x84b\0/\xDDV[`\0a\x01\0\x82Q\x81\x85Rb\x001\xF0\x82\x86\x01\x82b\0/\xAFV[\x91PP` \x83\x01Q` \x85\x01R`@\x83\x01Q`@\x85\x01R``\x83\x01Q\x84\x82\x03``\x86\x01Rb\x002 \x82\x82b\0/\xAFV[\x91PP`\x80\x83\x01Q`\x80\x85\x01R`\xA0\x83\x01Q`\xA0\x85\x01R`\xC0\x83\x01Q\x15\x15`\xC0\x85\x01R`\xE0\x83\x01Q\x84\x82\x03`\xE0\x86\x01Rb\x002\\\x82\x82b\0/\xAFV[\x95\x94PPPPPV[`\0` \x80\x83R`\xA0\x83\x01\x84Q\x82\x85\x01R\x81\x85\x01Q`\x80`@\x86\x01R\x81\x81Q\x80\x84R`\xC0\x87\x01\x91P`\xC0\x81`\x05\x1B\x88\x01\x01\x93P\x84\x83\x01\x92P`\0[\x81\x81\x10\x15b\x002\xF0W\x7F\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF@\x88\x86\x03\x01\x83Rb\x002\xDD\x85\x85Qb\0/\xAFV[\x94P\x92\x85\x01\x92\x91\x85\x01\x91`\x01\x01b\x002\xA0V[PPPP`@\x85\x01Q``\x85\x01R``\x85\x01Q\x91P`\x1F\x19\x84\x82\x03\x01`\x80\x85\x01Rb\x002\\\x81\x83b\x001\xD8V[`\0` \x82\x84\x03\x12\x15b\x0030W`\0\x80\xFD[PQ\x91\x90PV[`\0\x83Qb\x003K\x81\x84` \x88\x01b\0/\x89V[\x83Q\x90\x83\x01\x90b\x003a\x81\x83` \x88\x01b\0/\x89V[\x01\x94\x93PPPPV[`\0` \x82\x84\x03\x12\x15b\x003}W`\0\x80\xFD[\x81Qb\0&8\x81b\0.\xBBV[\x80\x82\x01\x80\x82\x11\x15b\0\x18\x0CW\x7FNH{q\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`\0R`\x11`\x04R`$`\0\xFD\xFE`\x80`@R`@Qa\x04\x178\x03\x80a\x04\x17\x839\x81\x01`@\x81\x90Ra\0\"\x91a\x02hV[a\0,\x82\x82a\x003V[PPa\x03RV[a\0<\x82a\0\x92V[`@Q`\x01`\x01`\xA0\x1B\x03\x83\x16\x90\x7F\xBC|\xD7Z \xEE'\xFD\x9A\xDE\xBA\xB3 A\xF7U!M\xBCk\xFF\xA9\x0C\xC0\"[9\xDA.\\-;\x90`\0\x90\xA2\x80Q\x15a\0\x86Wa\0\x81\x82\x82a\x01\x0EV[PPPV[a\0\x8Ea\x01\x85V[PPV[\x80`\x01`\x01`\xA0\x1B\x03\x16;`\0\x03a\0\xCDW`@QcL\x9C\x8C\xE3`\xE0\x1B\x81R`\x01`\x01`\xA0\x1B\x03\x82\x16`\x04\x82\x01R`$\x01[`@Q\x80\x91\x03\x90\xFD[\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBC\x80T`\x01`\x01`\xA0\x1B\x03\x19\x16`\x01`\x01`\xA0\x1B\x03\x92\x90\x92\x16\x91\x90\x91\x17\x90UV[```\0\x80\x84`\x01`\x01`\xA0\x1B\x03\x16\x84`@Qa\x01+\x91\x90a\x036V[`\0`@Q\x80\x83\x03\x81\x85Z\xF4\x91PP=\x80`\0\x81\x14a\x01fW`@Q\x91P`\x1F\x19`?=\x01\x16\x82\x01`@R=\x82R=`\0` \x84\x01>a\x01kV[``\x91P[P\x90\x92P\x90Pa\x01|\x85\x83\x83a\x01\xA6V[\x95\x94PPPPPV[4\x15a\x01\xA4W`@Qc\xB3\x98\x97\x9F`\xE0\x1B\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[V[``\x82a\x01\xBBWa\x01\xB6\x82a\x02\x05V[a\x01\xFEV[\x81Q\x15\x80\x15a\x01\xD2WP`\x01`\x01`\xA0\x1B\x03\x84\x16;\x15[\x15a\x01\xFBW`@Qc\x99\x96\xB3\x15`\xE0\x1B\x81R`\x01`\x01`\xA0\x1B\x03\x85\x16`\x04\x82\x01R`$\x01a\0\xC4V[P\x80[\x93\x92PPPV[\x80Q\x15a\x02\x15W\x80Q\x80\x82` \x01\xFD[`@Qc\n\x12\xF5!`\xE1\x1B\x81R`\x04\x01`@Q\x80\x91\x03\x90\xFD[cNH{q`\xE0\x1B`\0R`A`\x04R`$`\0\xFD[`\0[\x83\x81\x10\x15a\x02_W\x81\x81\x01Q\x83\x82\x01R` \x01a\x02GV[PP`\0\x91\x01RV[`\0\x80`@\x83\x85\x03\x12\x15a\x02{W`\0\x80\xFD[\x82Q`\x01`\x01`\xA0\x1B\x03\x81\x16\x81\x14a\x02\x92W`\0\x80\xFD[` \x84\x01Q\x90\x92P`\x01`\x01`@\x1B\x03\x80\x82\x11\x15a\x02\xAFW`\0\x80\xFD[\x81\x85\x01\x91P\x85`\x1F\x83\x01\x12a\x02\xC3W`\0\x80\xFD[\x81Q\x81\x81\x11\x15a\x02\xD5Wa\x02\xD5a\x02.V[`@Q`\x1F\x82\x01`\x1F\x19\x90\x81\x16`?\x01\x16\x81\x01\x90\x83\x82\x11\x81\x83\x10\x17\x15a\x02\xFDWa\x02\xFDa\x02.V[\x81`@R\x82\x81R\x88` \x84\x87\x01\x01\x11\x15a\x03\x16W`\0\x80\xFD[a\x03'\x83` \x83\x01` \x88\x01a\x02DV[\x80\x95PPPPPP\x92P\x92\x90PV[`\0\x82Qa\x03H\x81\x84` \x87\x01a\x02DV[\x91\x90\x91\x01\x92\x91PPV[`\xB7\x80a\x03``\09`\0\xF3\xFE`\x80`@R`\n`\x0CV[\0[`\x18`\x14`\x1AV[`^V[V[`\0`Y\x7F6\x08\x94\xA1;\xA1\xA3!\x06g\xC8(I-\xB9\x8D\xCA> v\xCC75\xA9 \xA3\xCAP]8+\xBCTs\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x16\x90V[\x90P\x90V[6`\0\x807`\0\x806`\0\x84Z\xF4=`\0\x80>\x80\x80\x15`|W=`\0\xF3[=`\0\xFD\xFE\xA2dipfsX\"\x12 \xE5\xD4\xE8\x85\xAEN\x1DE\x8A3oD\xA5F\xC7\x08\xCB\xFA\x1B\xFA\xE5d\\\xBE\xB0\xFF\xF8\x0C\xAAL\xDD\x1CdsolcC\0\x08\x17\x003\xA2dipfsX\"\x12 \xB0&\xBB@\xBE\x91\x08\x9F\x168\x8F\x11\xE5_\x8Be\x8E\n\xD7\x90\xE1\xEDTL\xCA\x83\xCE#r\xD96\xC6dsolcC\0\x08\x17\x003";
    /// The deployed bytecode of the contract.
    pub static SIMPLEWALLET_DEPLOYED_BYTECODE: ::ethers::core::types::Bytes = ::ethers::core::types::Bytes::from_static(
        __DEPLOYED_BYTECODE,
    );
    pub struct SimpleWallet<M>(::ethers::contract::Contract<M>);
    impl<M> ::core::clone::Clone for SimpleWallet<M> {
        fn clone(&self) -> Self {
            Self(::core::clone::Clone::clone(&self.0))
        }
    }
    impl<M> ::core::ops::Deref for SimpleWallet<M> {
        type Target = ::ethers::contract::Contract<M>;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }
    impl<M> ::core::ops::DerefMut for SimpleWallet<M> {
        fn deref_mut(&mut self) -> &mut Self::Target {
            &mut self.0
        }
    }
    impl<M> ::core::fmt::Debug for SimpleWallet<M> {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple(::core::stringify!(SimpleWallet))
                .field(&self.address())
                .finish()
        }
    }
    impl<M: ::ethers::providers::Middleware> SimpleWallet<M> {
        /// Creates a new contract instance with the specified `ethers` client at
        /// `address`. The contract derefs to a `ethers::Contract` object.
        pub fn new<T: Into<::ethers::core::types::Address>>(
            address: T,
            client: ::std::sync::Arc<M>,
        ) -> Self {
            Self(
                ::ethers::contract::Contract::new(
                    address.into(),
                    SIMPLEWALLET_ABI.clone(),
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
                SIMPLEWALLET_ABI.clone(),
                SIMPLEWALLET_BYTECODE.clone().into(),
                client,
            );
            let deployer = factory.deploy(constructor_args)?;
            let deployer = ::ethers::contract::ContractDeployer::new(deployer);
            Ok(deployer)
        }
        ///Calls the contract's `TIMELOCK_PERIOD` (0x4a5bcbf8) function
        pub fn timelock_period(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ::ethers::core::types::U256> {
            self.0
                .method_hash([74, 91, 203, 248], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `acceptanceSubjectTemplates` (0x5bafadda) function
        pub fn acceptance_subject_templates(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
        > {
            self.0
                .method_hash([91, 175, 173, 218], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `completeRecovery` (0x6b0c717e) function
        pub fn complete_recovery(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([107, 12, 113, 126], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `computeAcceptanceTemplateId` (0x32ccc2f2) function
        pub fn compute_acceptance_template_id(
            &self,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ::ethers::core::types::U256> {
            self.0
                .method_hash([50, 204, 194, 242], template_idx)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `computeEmailAuthAddress` (0x81520782) function
        pub fn compute_email_auth_address(
            &self,
            account_salt: [u8; 32],
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([129, 82, 7, 130], account_salt)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `computeRecoveryTemplateId` (0x6da99515) function
        pub fn compute_recovery_template_id(
            &self,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ::ethers::core::types::U256> {
            self.0
                .method_hash([109, 169, 149, 21], template_idx)
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
        ///Calls the contract's `dkimAddr` (0x73357f85) function
        pub fn dkim_addr(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([115, 53, 127, 133], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `emailAuthImplementation` (0xb6201692) function
        pub fn email_auth_implementation(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([182, 32, 22, 146], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `emailAuthImplementationAddr` (0x1098e02e) function
        pub fn email_auth_implementation_addr(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([16, 152, 224, 46], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `guardians` (0x0633b14a) function
        pub fn guardians(
            &self,
            p0: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, u8> {
            self.0
                .method_hash([6, 51, 177, 74], p0)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `handleAcceptance` (0x0481af67) function
        pub fn handle_acceptance(
            &self,
            email_auth_msg: EmailAuthMsg,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([4, 129, 175, 103], (email_auth_msg, template_idx))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `handleRecovery` (0xb68126fa) function
        pub fn handle_recovery(
            &self,
            email_auth_msg: EmailAuthMsg,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([182, 129, 38, 250], (email_auth_msg, template_idx))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `initialize` (0xf8c8765e) function
        pub fn initialize(
            &self,
            initial_owner: ::ethers::core::types::Address,
            verifier: ::ethers::core::types::Address,
            dkim: ::ethers::core::types::Address,
            email_auth_implementation: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash(
                    [248, 200, 118, 94],
                    (initial_owner, verifier, dkim, email_auth_implementation),
                )
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `isRecovering` (0x91ac2788) function
        pub fn is_recovering(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, bool> {
            self.0
                .method_hash([145, 172, 39, 136], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `newSignerCandidate` (0x71ce6064) function
        pub fn new_signer_candidate(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([113, 206, 96, 100], ())
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
        ///Calls the contract's `recoverySubjectTemplates` (0x3e91cdcd) function
        pub fn recovery_subject_templates(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
        > {
            self.0
                .method_hash([62, 145, 205, 205], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `rejectRecovery` (0xd446bb9a) function
        pub fn reject_recovery(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([212, 70, 187, 154], ())
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
        ///Calls the contract's `requestGuardian` (0xdbeb882a) function
        pub fn request_guardian(
            &self,
            guardian: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([219, 235, 136, 42], guardian)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `timelock` (0xd33219b4) function
        pub fn timelock(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<M, ::ethers::core::types::U256> {
            self.0
                .method_hash([211, 50, 25, 180], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `transfer` (0xa9059cbb) function
        pub fn transfer(
            &self,
            to: ::ethers::core::types::Address,
            amount: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([169, 5, 156, 187], (to, amount))
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
        ///Calls the contract's `withdraw` (0x2e1a7d4d) function
        pub fn withdraw(
            &self,
            amount: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([46, 26, 125, 77], amount)
                .expect("method not found (this should never happen)")
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
        /// Returns an `Event` builder for all the events of this contract.
        pub fn events(
            &self,
        ) -> ::ethers::contract::builders::Event<
            ::std::sync::Arc<M>,
            M,
            SimpleWalletEvents,
        > {
            self.0.event_with_filter(::core::default::Default::default())
        }
    }
    impl<M: ::ethers::providers::Middleware> From<::ethers::contract::Contract<M>>
    for SimpleWallet<M> {
        fn from(contract: ::ethers::contract::Contract<M>) -> Self {
            Self::new(contract.address(), contract.client())
        }
    }
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
    ///Container type for all of the contract's custom errors
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum SimpleWalletErrors {
        InvalidInitialization(InvalidInitialization),
        NotInitializing(NotInitializing),
        OwnableInvalidOwner(OwnableInvalidOwner),
        OwnableUnauthorizedAccount(OwnableUnauthorizedAccount),
        /// The standard solidity revert string, with selector
        /// Error(string) -- 0x08c379a0
        RevertString(::std::string::String),
    }
    impl ::ethers::core::abi::AbiDecode for SimpleWalletErrors {
        fn decode(
            data: impl AsRef<[u8]>,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::AbiError> {
            let data = data.as_ref();
            if let Ok(decoded) = <::std::string::String as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RevertString(decoded));
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
            Err(::ethers::core::abi::Error::InvalidData.into())
        }
    }
    impl ::ethers::core::abi::AbiEncode for SimpleWalletErrors {
        fn encode(self) -> ::std::vec::Vec<u8> {
            match self {
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
                Self::RevertString(s) => ::ethers::core::abi::AbiEncode::encode(s),
            }
        }
    }
    impl ::ethers::contract::ContractRevert for SimpleWalletErrors {
        fn valid_selector(selector: [u8; 4]) -> bool {
            match selector {
                [0x08, 0xc3, 0x79, 0xa0] => true,
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
                _ => false,
            }
        }
    }
    impl ::core::fmt::Display for SimpleWalletErrors {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
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
                Self::RevertString(s) => ::core::fmt::Display::fmt(s, f),
            }
        }
    }
    impl ::core::convert::From<::std::string::String> for SimpleWalletErrors {
        fn from(value: String) -> Self {
            Self::RevertString(value)
        }
    }
    impl ::core::convert::From<InvalidInitialization> for SimpleWalletErrors {
        fn from(value: InvalidInitialization) -> Self {
            Self::InvalidInitialization(value)
        }
    }
    impl ::core::convert::From<NotInitializing> for SimpleWalletErrors {
        fn from(value: NotInitializing) -> Self {
            Self::NotInitializing(value)
        }
    }
    impl ::core::convert::From<OwnableInvalidOwner> for SimpleWalletErrors {
        fn from(value: OwnableInvalidOwner) -> Self {
            Self::OwnableInvalidOwner(value)
        }
    }
    impl ::core::convert::From<OwnableUnauthorizedAccount> for SimpleWalletErrors {
        fn from(value: OwnableUnauthorizedAccount) -> Self {
            Self::OwnableUnauthorizedAccount(value)
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
    ///Container type for all of the contract's events
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum SimpleWalletEvents {
        InitializedFilter(InitializedFilter),
        OwnershipTransferredFilter(OwnershipTransferredFilter),
    }
    impl ::ethers::contract::EthLogDecode for SimpleWalletEvents {
        fn decode_log(
            log: &::ethers::core::abi::RawLog,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::Error> {
            if let Ok(decoded) = InitializedFilter::decode_log(log) {
                return Ok(SimpleWalletEvents::InitializedFilter(decoded));
            }
            if let Ok(decoded) = OwnershipTransferredFilter::decode_log(log) {
                return Ok(SimpleWalletEvents::OwnershipTransferredFilter(decoded));
            }
            Err(::ethers::core::abi::Error::InvalidData)
        }
    }
    impl ::core::fmt::Display for SimpleWalletEvents {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::InitializedFilter(element) => ::core::fmt::Display::fmt(element, f),
                Self::OwnershipTransferredFilter(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
            }
        }
    }
    impl ::core::convert::From<InitializedFilter> for SimpleWalletEvents {
        fn from(value: InitializedFilter) -> Self {
            Self::InitializedFilter(value)
        }
    }
    impl ::core::convert::From<OwnershipTransferredFilter> for SimpleWalletEvents {
        fn from(value: OwnershipTransferredFilter) -> Self {
            Self::OwnershipTransferredFilter(value)
        }
    }
    ///Container type for all input parameters for the `TIMELOCK_PERIOD` function with signature `TIMELOCK_PERIOD()` and selector `0x4a5bcbf8`
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
    #[ethcall(name = "TIMELOCK_PERIOD", abi = "TIMELOCK_PERIOD()")]
    pub struct TimelockPeriodCall;
    ///Container type for all input parameters for the `acceptanceSubjectTemplates` function with signature `acceptanceSubjectTemplates()` and selector `0x5bafadda`
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
    #[ethcall(name = "acceptanceSubjectTemplates", abi = "acceptanceSubjectTemplates()")]
    pub struct AcceptanceSubjectTemplatesCall;
    ///Container type for all input parameters for the `completeRecovery` function with signature `completeRecovery()` and selector `0x6b0c717e`
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
    #[ethcall(name = "completeRecovery", abi = "completeRecovery()")]
    pub struct CompleteRecoveryCall;
    ///Container type for all input parameters for the `computeAcceptanceTemplateId` function with signature `computeAcceptanceTemplateId(uint256)` and selector `0x32ccc2f2`
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
        name = "computeAcceptanceTemplateId",
        abi = "computeAcceptanceTemplateId(uint256)"
    )]
    pub struct ComputeAcceptanceTemplateIdCall {
        pub template_idx: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `computeEmailAuthAddress` function with signature `computeEmailAuthAddress(bytes32)` and selector `0x81520782`
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
        name = "computeEmailAuthAddress",
        abi = "computeEmailAuthAddress(bytes32)"
    )]
    pub struct ComputeEmailAuthAddressCall {
        pub account_salt: [u8; 32],
    }
    ///Container type for all input parameters for the `computeRecoveryTemplateId` function with signature `computeRecoveryTemplateId(uint256)` and selector `0x6da99515`
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
        name = "computeRecoveryTemplateId",
        abi = "computeRecoveryTemplateId(uint256)"
    )]
    pub struct ComputeRecoveryTemplateIdCall {
        pub template_idx: ::ethers::core::types::U256,
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
    ///Container type for all input parameters for the `dkimAddr` function with signature `dkimAddr()` and selector `0x73357f85`
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
    #[ethcall(name = "dkimAddr", abi = "dkimAddr()")]
    pub struct DkimAddrCall;
    ///Container type for all input parameters for the `emailAuthImplementation` function with signature `emailAuthImplementation()` and selector `0xb6201692`
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
    #[ethcall(name = "emailAuthImplementation", abi = "emailAuthImplementation()")]
    pub struct EmailAuthImplementationCall;
    ///Container type for all input parameters for the `emailAuthImplementationAddr` function with signature `emailAuthImplementationAddr()` and selector `0x1098e02e`
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
        name = "emailAuthImplementationAddr",
        abi = "emailAuthImplementationAddr()"
    )]
    pub struct EmailAuthImplementationAddrCall;
    ///Container type for all input parameters for the `guardians` function with signature `guardians(address)` and selector `0x0633b14a`
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
    #[ethcall(name = "guardians", abi = "guardians(address)")]
    pub struct GuardiansCall(pub ::ethers::core::types::Address);
    ///Container type for all input parameters for the `handleAcceptance` function with signature `handleAcceptance((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)),uint256)` and selector `0x0481af67`
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
        name = "handleAcceptance",
        abi = "handleAcceptance((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)),uint256)"
    )]
    pub struct HandleAcceptanceCall {
        pub email_auth_msg: EmailAuthMsg,
        pub template_idx: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `handleRecovery` function with signature `handleRecovery((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)),uint256)` and selector `0xb68126fa`
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
        name = "handleRecovery",
        abi = "handleRecovery((uint256,bytes[],uint256,(string,bytes32,uint256,string,bytes32,bytes32,bool,bytes)),uint256)"
    )]
    pub struct HandleRecoveryCall {
        pub email_auth_msg: EmailAuthMsg,
        pub template_idx: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `initialize` function with signature `initialize(address,address,address,address)` and selector `0xf8c8765e`
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
    #[ethcall(name = "initialize", abi = "initialize(address,address,address,address)")]
    pub struct InitializeCall {
        pub initial_owner: ::ethers::core::types::Address,
        pub verifier: ::ethers::core::types::Address,
        pub dkim: ::ethers::core::types::Address,
        pub email_auth_implementation: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `isRecovering` function with signature `isRecovering()` and selector `0x91ac2788`
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
    #[ethcall(name = "isRecovering", abi = "isRecovering()")]
    pub struct IsRecoveringCall;
    ///Container type for all input parameters for the `newSignerCandidate` function with signature `newSignerCandidate()` and selector `0x71ce6064`
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
    #[ethcall(name = "newSignerCandidate", abi = "newSignerCandidate()")]
    pub struct NewSignerCandidateCall;
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
    ///Container type for all input parameters for the `recoverySubjectTemplates` function with signature `recoverySubjectTemplates()` and selector `0x3e91cdcd`
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
    #[ethcall(name = "recoverySubjectTemplates", abi = "recoverySubjectTemplates()")]
    pub struct RecoverySubjectTemplatesCall;
    ///Container type for all input parameters for the `rejectRecovery` function with signature `rejectRecovery()` and selector `0xd446bb9a`
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
    #[ethcall(name = "rejectRecovery", abi = "rejectRecovery()")]
    pub struct RejectRecoveryCall;
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
    ///Container type for all input parameters for the `requestGuardian` function with signature `requestGuardian(address)` and selector `0xdbeb882a`
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
    #[ethcall(name = "requestGuardian", abi = "requestGuardian(address)")]
    pub struct RequestGuardianCall {
        pub guardian: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `timelock` function with signature `timelock()` and selector `0xd33219b4`
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
    #[ethcall(name = "timelock", abi = "timelock()")]
    pub struct TimelockCall;
    ///Container type for all input parameters for the `transfer` function with signature `transfer(address,uint256)` and selector `0xa9059cbb`
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
    #[ethcall(name = "transfer", abi = "transfer(address,uint256)")]
    pub struct TransferCall {
        pub to: ::ethers::core::types::Address,
        pub amount: ::ethers::core::types::U256,
    }
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
    ///Container type for all input parameters for the `withdraw` function with signature `withdraw(uint256)` and selector `0x2e1a7d4d`
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
    #[ethcall(name = "withdraw", abi = "withdraw(uint256)")]
    pub struct WithdrawCall {
        pub amount: ::ethers::core::types::U256,
    }
    ///Container type for all of the contract's call
    #[derive(Clone, ::ethers::contract::EthAbiType, Debug, PartialEq, Eq, Hash)]
    pub enum SimpleWalletCalls {
        TimelockPeriod(TimelockPeriodCall),
        AcceptanceSubjectTemplates(AcceptanceSubjectTemplatesCall),
        CompleteRecovery(CompleteRecoveryCall),
        ComputeAcceptanceTemplateId(ComputeAcceptanceTemplateIdCall),
        ComputeEmailAuthAddress(ComputeEmailAuthAddressCall),
        ComputeRecoveryTemplateId(ComputeRecoveryTemplateIdCall),
        Dkim(DkimCall),
        DkimAddr(DkimAddrCall),
        EmailAuthImplementation(EmailAuthImplementationCall),
        EmailAuthImplementationAddr(EmailAuthImplementationAddrCall),
        Guardians(GuardiansCall),
        HandleAcceptance(HandleAcceptanceCall),
        HandleRecovery(HandleRecoveryCall),
        Initialize(InitializeCall),
        IsRecovering(IsRecoveringCall),
        NewSignerCandidate(NewSignerCandidateCall),
        Owner(OwnerCall),
        RecoverySubjectTemplates(RecoverySubjectTemplatesCall),
        RejectRecovery(RejectRecoveryCall),
        RenounceOwnership(RenounceOwnershipCall),
        RequestGuardian(RequestGuardianCall),
        Timelock(TimelockCall),
        Transfer(TransferCall),
        TransferOwnership(TransferOwnershipCall),
        Verifier(VerifierCall),
        VerifierAddr(VerifierAddrCall),
        Withdraw(WithdrawCall),
    }
    impl ::ethers::core::abi::AbiDecode for SimpleWalletCalls {
        fn decode(
            data: impl AsRef<[u8]>,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::AbiError> {
            let data = data.as_ref();
            if let Ok(decoded) = <TimelockPeriodCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::TimelockPeriod(decoded));
            }
            if let Ok(decoded) = <AcceptanceSubjectTemplatesCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AcceptanceSubjectTemplates(decoded));
            }
            if let Ok(decoded) = <CompleteRecoveryCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::CompleteRecovery(decoded));
            }
            if let Ok(decoded) = <ComputeAcceptanceTemplateIdCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ComputeAcceptanceTemplateId(decoded));
            }
            if let Ok(decoded) = <ComputeEmailAuthAddressCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ComputeEmailAuthAddress(decoded));
            }
            if let Ok(decoded) = <ComputeRecoveryTemplateIdCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ComputeRecoveryTemplateId(decoded));
            }
            if let Ok(decoded) = <DkimCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Dkim(decoded));
            }
            if let Ok(decoded) = <DkimAddrCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::DkimAddr(decoded));
            }
            if let Ok(decoded) = <EmailAuthImplementationCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::EmailAuthImplementation(decoded));
            }
            if let Ok(decoded) = <EmailAuthImplementationAddrCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::EmailAuthImplementationAddr(decoded));
            }
            if let Ok(decoded) = <GuardiansCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Guardians(decoded));
            }
            if let Ok(decoded) = <HandleAcceptanceCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::HandleAcceptance(decoded));
            }
            if let Ok(decoded) = <HandleRecoveryCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::HandleRecovery(decoded));
            }
            if let Ok(decoded) = <InitializeCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Initialize(decoded));
            }
            if let Ok(decoded) = <IsRecoveringCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::IsRecovering(decoded));
            }
            if let Ok(decoded) = <NewSignerCandidateCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::NewSignerCandidate(decoded));
            }
            if let Ok(decoded) = <OwnerCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Owner(decoded));
            }
            if let Ok(decoded) = <RecoverySubjectTemplatesCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RecoverySubjectTemplates(decoded));
            }
            if let Ok(decoded) = <RejectRecoveryCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RejectRecovery(decoded));
            }
            if let Ok(decoded) = <RenounceOwnershipCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RenounceOwnership(decoded));
            }
            if let Ok(decoded) = <RequestGuardianCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RequestGuardian(decoded));
            }
            if let Ok(decoded) = <TimelockCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Timelock(decoded));
            }
            if let Ok(decoded) = <TransferCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Transfer(decoded));
            }
            if let Ok(decoded) = <TransferOwnershipCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::TransferOwnership(decoded));
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
            if let Ok(decoded) = <WithdrawCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::Withdraw(decoded));
            }
            Err(::ethers::core::abi::Error::InvalidData.into())
        }
    }
    impl ::ethers::core::abi::AbiEncode for SimpleWalletCalls {
        fn encode(self) -> Vec<u8> {
            match self {
                Self::TimelockPeriod(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::AcceptanceSubjectTemplates(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::CompleteRecovery(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ComputeAcceptanceTemplateId(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ComputeEmailAuthAddress(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ComputeRecoveryTemplateId(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Dkim(element) => ::ethers::core::abi::AbiEncode::encode(element),
                Self::DkimAddr(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::EmailAuthImplementation(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::EmailAuthImplementationAddr(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Guardians(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::HandleAcceptance(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::HandleRecovery(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Initialize(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::IsRecovering(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::NewSignerCandidate(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Owner(element) => ::ethers::core::abi::AbiEncode::encode(element),
                Self::RecoverySubjectTemplates(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RejectRecovery(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RenounceOwnership(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RequestGuardian(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Timelock(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Transfer(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::TransferOwnership(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Verifier(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::VerifierAddr(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::Withdraw(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
            }
        }
    }
    impl ::core::fmt::Display for SimpleWalletCalls {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::TimelockPeriod(element) => ::core::fmt::Display::fmt(element, f),
                Self::AcceptanceSubjectTemplates(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::CompleteRecovery(element) => ::core::fmt::Display::fmt(element, f),
                Self::ComputeAcceptanceTemplateId(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::ComputeEmailAuthAddress(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::ComputeRecoveryTemplateId(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Dkim(element) => ::core::fmt::Display::fmt(element, f),
                Self::DkimAddr(element) => ::core::fmt::Display::fmt(element, f),
                Self::EmailAuthImplementation(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::EmailAuthImplementationAddr(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Guardians(element) => ::core::fmt::Display::fmt(element, f),
                Self::HandleAcceptance(element) => ::core::fmt::Display::fmt(element, f),
                Self::HandleRecovery(element) => ::core::fmt::Display::fmt(element, f),
                Self::Initialize(element) => ::core::fmt::Display::fmt(element, f),
                Self::IsRecovering(element) => ::core::fmt::Display::fmt(element, f),
                Self::NewSignerCandidate(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Owner(element) => ::core::fmt::Display::fmt(element, f),
                Self::RecoverySubjectTemplates(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::RejectRecovery(element) => ::core::fmt::Display::fmt(element, f),
                Self::RenounceOwnership(element) => ::core::fmt::Display::fmt(element, f),
                Self::RequestGuardian(element) => ::core::fmt::Display::fmt(element, f),
                Self::Timelock(element) => ::core::fmt::Display::fmt(element, f),
                Self::Transfer(element) => ::core::fmt::Display::fmt(element, f),
                Self::TransferOwnership(element) => ::core::fmt::Display::fmt(element, f),
                Self::Verifier(element) => ::core::fmt::Display::fmt(element, f),
                Self::VerifierAddr(element) => ::core::fmt::Display::fmt(element, f),
                Self::Withdraw(element) => ::core::fmt::Display::fmt(element, f),
            }
        }
    }
    impl ::core::convert::From<TimelockPeriodCall> for SimpleWalletCalls {
        fn from(value: TimelockPeriodCall) -> Self {
            Self::TimelockPeriod(value)
        }
    }
    impl ::core::convert::From<AcceptanceSubjectTemplatesCall> for SimpleWalletCalls {
        fn from(value: AcceptanceSubjectTemplatesCall) -> Self {
            Self::AcceptanceSubjectTemplates(value)
        }
    }
    impl ::core::convert::From<CompleteRecoveryCall> for SimpleWalletCalls {
        fn from(value: CompleteRecoveryCall) -> Self {
            Self::CompleteRecovery(value)
        }
    }
    impl ::core::convert::From<ComputeAcceptanceTemplateIdCall> for SimpleWalletCalls {
        fn from(value: ComputeAcceptanceTemplateIdCall) -> Self {
            Self::ComputeAcceptanceTemplateId(value)
        }
    }
    impl ::core::convert::From<ComputeEmailAuthAddressCall> for SimpleWalletCalls {
        fn from(value: ComputeEmailAuthAddressCall) -> Self {
            Self::ComputeEmailAuthAddress(value)
        }
    }
    impl ::core::convert::From<ComputeRecoveryTemplateIdCall> for SimpleWalletCalls {
        fn from(value: ComputeRecoveryTemplateIdCall) -> Self {
            Self::ComputeRecoveryTemplateId(value)
        }
    }
    impl ::core::convert::From<DkimCall> for SimpleWalletCalls {
        fn from(value: DkimCall) -> Self {
            Self::Dkim(value)
        }
    }
    impl ::core::convert::From<DkimAddrCall> for SimpleWalletCalls {
        fn from(value: DkimAddrCall) -> Self {
            Self::DkimAddr(value)
        }
    }
    impl ::core::convert::From<EmailAuthImplementationCall> for SimpleWalletCalls {
        fn from(value: EmailAuthImplementationCall) -> Self {
            Self::EmailAuthImplementation(value)
        }
    }
    impl ::core::convert::From<EmailAuthImplementationAddrCall> for SimpleWalletCalls {
        fn from(value: EmailAuthImplementationAddrCall) -> Self {
            Self::EmailAuthImplementationAddr(value)
        }
    }
    impl ::core::convert::From<GuardiansCall> for SimpleWalletCalls {
        fn from(value: GuardiansCall) -> Self {
            Self::Guardians(value)
        }
    }
    impl ::core::convert::From<HandleAcceptanceCall> for SimpleWalletCalls {
        fn from(value: HandleAcceptanceCall) -> Self {
            Self::HandleAcceptance(value)
        }
    }
    impl ::core::convert::From<HandleRecoveryCall> for SimpleWalletCalls {
        fn from(value: HandleRecoveryCall) -> Self {
            Self::HandleRecovery(value)
        }
    }
    impl ::core::convert::From<InitializeCall> for SimpleWalletCalls {
        fn from(value: InitializeCall) -> Self {
            Self::Initialize(value)
        }
    }
    impl ::core::convert::From<IsRecoveringCall> for SimpleWalletCalls {
        fn from(value: IsRecoveringCall) -> Self {
            Self::IsRecovering(value)
        }
    }
    impl ::core::convert::From<NewSignerCandidateCall> for SimpleWalletCalls {
        fn from(value: NewSignerCandidateCall) -> Self {
            Self::NewSignerCandidate(value)
        }
    }
    impl ::core::convert::From<OwnerCall> for SimpleWalletCalls {
        fn from(value: OwnerCall) -> Self {
            Self::Owner(value)
        }
    }
    impl ::core::convert::From<RecoverySubjectTemplatesCall> for SimpleWalletCalls {
        fn from(value: RecoverySubjectTemplatesCall) -> Self {
            Self::RecoverySubjectTemplates(value)
        }
    }
    impl ::core::convert::From<RejectRecoveryCall> for SimpleWalletCalls {
        fn from(value: RejectRecoveryCall) -> Self {
            Self::RejectRecovery(value)
        }
    }
    impl ::core::convert::From<RenounceOwnershipCall> for SimpleWalletCalls {
        fn from(value: RenounceOwnershipCall) -> Self {
            Self::RenounceOwnership(value)
        }
    }
    impl ::core::convert::From<RequestGuardianCall> for SimpleWalletCalls {
        fn from(value: RequestGuardianCall) -> Self {
            Self::RequestGuardian(value)
        }
    }
    impl ::core::convert::From<TimelockCall> for SimpleWalletCalls {
        fn from(value: TimelockCall) -> Self {
            Self::Timelock(value)
        }
    }
    impl ::core::convert::From<TransferCall> for SimpleWalletCalls {
        fn from(value: TransferCall) -> Self {
            Self::Transfer(value)
        }
    }
    impl ::core::convert::From<TransferOwnershipCall> for SimpleWalletCalls {
        fn from(value: TransferOwnershipCall) -> Self {
            Self::TransferOwnership(value)
        }
    }
    impl ::core::convert::From<VerifierCall> for SimpleWalletCalls {
        fn from(value: VerifierCall) -> Self {
            Self::Verifier(value)
        }
    }
    impl ::core::convert::From<VerifierAddrCall> for SimpleWalletCalls {
        fn from(value: VerifierAddrCall) -> Self {
            Self::VerifierAddr(value)
        }
    }
    impl ::core::convert::From<WithdrawCall> for SimpleWalletCalls {
        fn from(value: WithdrawCall) -> Self {
            Self::Withdraw(value)
        }
    }
    ///Container type for all return fields from the `TIMELOCK_PERIOD` function with signature `TIMELOCK_PERIOD()` and selector `0x4a5bcbf8`
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
    pub struct TimelockPeriodReturn(pub ::ethers::core::types::U256);
    ///Container type for all return fields from the `acceptanceSubjectTemplates` function with signature `acceptanceSubjectTemplates()` and selector `0x5bafadda`
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
    pub struct AcceptanceSubjectTemplatesReturn(
        pub ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
    );
    ///Container type for all return fields from the `computeAcceptanceTemplateId` function with signature `computeAcceptanceTemplateId(uint256)` and selector `0x32ccc2f2`
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
    pub struct ComputeAcceptanceTemplateIdReturn(pub ::ethers::core::types::U256);
    ///Container type for all return fields from the `computeEmailAuthAddress` function with signature `computeEmailAuthAddress(bytes32)` and selector `0x81520782`
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
    pub struct ComputeEmailAuthAddressReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `computeRecoveryTemplateId` function with signature `computeRecoveryTemplateId(uint256)` and selector `0x6da99515`
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
    pub struct ComputeRecoveryTemplateIdReturn(pub ::ethers::core::types::U256);
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
    ///Container type for all return fields from the `dkimAddr` function with signature `dkimAddr()` and selector `0x73357f85`
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
    pub struct DkimAddrReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `emailAuthImplementation` function with signature `emailAuthImplementation()` and selector `0xb6201692`
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
    pub struct EmailAuthImplementationReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `emailAuthImplementationAddr` function with signature `emailAuthImplementationAddr()` and selector `0x1098e02e`
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
    pub struct EmailAuthImplementationAddrReturn(pub ::ethers::core::types::Address);
    ///Container type for all return fields from the `guardians` function with signature `guardians(address)` and selector `0x0633b14a`
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
    pub struct GuardiansReturn(pub u8);
    ///Container type for all return fields from the `isRecovering` function with signature `isRecovering()` and selector `0x91ac2788`
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
    pub struct IsRecoveringReturn(pub bool);
    ///Container type for all return fields from the `newSignerCandidate` function with signature `newSignerCandidate()` and selector `0x71ce6064`
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
    pub struct NewSignerCandidateReturn(pub ::ethers::core::types::Address);
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
    ///Container type for all return fields from the `recoverySubjectTemplates` function with signature `recoverySubjectTemplates()` and selector `0x3e91cdcd`
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
    pub struct RecoverySubjectTemplatesReturn(
        pub ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
    );
    ///Container type for all return fields from the `timelock` function with signature `timelock()` and selector `0xd33219b4`
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
    pub struct TimelockReturn(pub ::ethers::core::types::U256);
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
