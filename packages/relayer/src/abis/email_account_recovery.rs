pub use email_account_recovery::*;
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
pub mod email_account_recovery {
    #[allow(deprecated)]
    fn __abi() -> ::ethers::core::abi::Abi {
        ::ethers::core::abi::ethabi::Contract {
            constructor: ::core::option::Option::None,
            functions: ::core::convert::From::from([
                (
                    ::std::borrow::ToOwned::to_owned("acceptanceCommandTemplates"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "acceptanceCommandTemplates",
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
                            state_mutability: ::ethers::core::abi::ethabi::StateMutability::View,
                        },
                    ],
                ),
                (
                    ::std::borrow::ToOwned::to_owned("completeRecovery"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("completeRecovery"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("account"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("completeCalldata"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Bytes,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes"),
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
                                    name: ::std::borrow::ToOwned::to_owned("recoveredAccount"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
                                    ),
                                },
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
                    ::std::borrow::ToOwned::to_owned(
                        "extractRecoveredAccountFromAcceptanceCommand",
                    ),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "extractRecoveredAccountFromAcceptanceCommand",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("commandParams"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::Bytes,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes[]"),
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
                    ::std::borrow::ToOwned::to_owned(
                        "extractRecoveredAccountFromRecoveryCommand",
                    ),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "extractRecoveredAccountFromRecoveryCommand",
                            ),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("commandParams"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Array(
                                        ::std::boxed::Box::new(
                                            ::ethers::core::abi::ethabi::ParamType::Bytes,
                                        ),
                                    ),
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("bytes[]"),
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
                    ::std::borrow::ToOwned::to_owned("isActivated"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned("isActivated"),
                            inputs: ::std::vec![
                                ::ethers::core::abi::ethabi::Param {
                                    name: ::std::borrow::ToOwned::to_owned("recoveredAccount"),
                                    kind: ::ethers::core::abi::ethabi::ParamType::Address,
                                    internal_type: ::core::option::Option::Some(
                                        ::std::borrow::ToOwned::to_owned("address"),
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
                    ::std::borrow::ToOwned::to_owned("recoveryCommandTemplates"),
                    ::std::vec![
                        ::ethers::core::abi::ethabi::Function {
                            name: ::std::borrow::ToOwned::to_owned(
                                "recoveryCommandTemplates",
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
            ]),
            events: ::std::collections::BTreeMap::new(),
            errors: ::std::collections::BTreeMap::new(),
            receive: false,
            fallback: false,
        }
    }
    ///The parsed JSON ABI of the contract.
    pub static EMAILACCOUNTRECOVERY_ABI: ::ethers::contract::Lazy<
        ::ethers::core::abi::Abi,
    > = ::ethers::contract::Lazy::new(__abi);
    pub struct EmailAccountRecovery<M>(::ethers::contract::Contract<M>);
    impl<M> ::core::clone::Clone for EmailAccountRecovery<M> {
        fn clone(&self) -> Self {
            Self(::core::clone::Clone::clone(&self.0))
        }
    }
    impl<M> ::core::ops::Deref for EmailAccountRecovery<M> {
        type Target = ::ethers::contract::Contract<M>;
        fn deref(&self) -> &Self::Target {
            &self.0
        }
    }
    impl<M> ::core::ops::DerefMut for EmailAccountRecovery<M> {
        fn deref_mut(&mut self) -> &mut Self::Target {
            &mut self.0
        }
    }
    impl<M> ::core::fmt::Debug for EmailAccountRecovery<M> {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            f.debug_tuple(::core::stringify!(EmailAccountRecovery))
                .field(&self.address())
                .finish()
        }
    }
    impl<M: ::ethers::providers::Middleware> EmailAccountRecovery<M> {
        /// Creates a new contract instance with the specified `ethers` client at
        /// `address`. The contract derefs to a `ethers::Contract` object.
        pub fn new<T: Into<::ethers::core::types::Address>>(
            address: T,
            client: ::std::sync::Arc<M>,
        ) -> Self {
            Self(
                ::ethers::contract::Contract::new(
                    address.into(),
                    EMAILACCOUNTRECOVERY_ABI.clone(),
                    client,
                ),
            )
        }
        ///Calls the contract's `acceptanceCommandTemplates` (0x222f6cb5) function
        pub fn acceptance_command_templates(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
        > {
            self.0
                .method_hash([34, 47, 108, 181], ())
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `completeRecovery` (0xc18d09cf) function
        pub fn complete_recovery(
            &self,
            account: ::ethers::core::types::Address,
            complete_calldata: ::ethers::core::types::Bytes,
        ) -> ::ethers::contract::builders::ContractCall<M, ()> {
            self.0
                .method_hash([193, 141, 9, 207], (account, complete_calldata))
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
        ///Calls the contract's `computeEmailAuthAddress` (0x3a8eab14) function
        pub fn compute_email_auth_address(
            &self,
            recovered_account: ::ethers::core::types::Address,
            account_salt: [u8; 32],
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([58, 142, 171, 20], (recovered_account, account_salt))
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
        ///Calls the contract's `extractRecoveredAccountFromAcceptanceCommand` (0x2c4ce129) function
        pub fn extract_recovered_account_from_acceptance_command(
            &self,
            command_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([44, 76, 225, 41], (command_params, template_idx))
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `extractRecoveredAccountFromRecoveryCommand` (0xa5e3ee70) function
        pub fn extract_recovered_account_from_recovery_command(
            &self,
            command_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
            template_idx: ::ethers::core::types::U256,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::ethers::core::types::Address,
        > {
            self.0
                .method_hash([165, 227, 238, 112], (command_params, template_idx))
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
        ///Calls the contract's `isActivated` (0xc9faa7c5) function
        pub fn is_activated(
            &self,
            recovered_account: ::ethers::core::types::Address,
        ) -> ::ethers::contract::builders::ContractCall<M, bool> {
            self.0
                .method_hash([201, 250, 167, 197], recovered_account)
                .expect("method not found (this should never happen)")
        }
        ///Calls the contract's `recoveryCommandTemplates` (0x3ef01b8f) function
        pub fn recovery_command_templates(
            &self,
        ) -> ::ethers::contract::builders::ContractCall<
            M,
            ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
        > {
            self.0
                .method_hash([62, 240, 27, 143], ())
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
    }
    impl<M: ::ethers::providers::Middleware> From<::ethers::contract::Contract<M>>
    for EmailAccountRecovery<M> {
        fn from(contract: ::ethers::contract::Contract<M>) -> Self {
            Self::new(contract.address(), contract.client())
        }
    }
    ///Container type for all input parameters for the `acceptanceCommandTemplates` function with signature `acceptanceCommandTemplates()` and selector `0x222f6cb5`
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
    #[ethcall(name = "acceptanceCommandTemplates", abi = "acceptanceCommandTemplates()")]
    pub struct AcceptanceCommandTemplatesCall;
    ///Container type for all input parameters for the `completeRecovery` function with signature `completeRecovery(address,bytes)` and selector `0xc18d09cf`
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
    #[ethcall(name = "completeRecovery", abi = "completeRecovery(address,bytes)")]
    pub struct CompleteRecoveryCall {
        pub account: ::ethers::core::types::Address,
        pub complete_calldata: ::ethers::core::types::Bytes,
    }
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
    ///Container type for all input parameters for the `computeEmailAuthAddress` function with signature `computeEmailAuthAddress(address,bytes32)` and selector `0x3a8eab14`
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
        abi = "computeEmailAuthAddress(address,bytes32)"
    )]
    pub struct ComputeEmailAuthAddressCall {
        pub recovered_account: ::ethers::core::types::Address,
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
    ///Container type for all input parameters for the `extractRecoveredAccountFromAcceptanceCommand` function with signature `extractRecoveredAccountFromAcceptanceCommand(bytes[],uint256)` and selector `0x2c4ce129`
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
        name = "extractRecoveredAccountFromAcceptanceCommand",
        abi = "extractRecoveredAccountFromAcceptanceCommand(bytes[],uint256)"
    )]
    pub struct ExtractRecoveredAccountFromAcceptanceCommandCall {
        pub command_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
        pub template_idx: ::ethers::core::types::U256,
    }
    ///Container type for all input parameters for the `extractRecoveredAccountFromRecoveryCommand` function with signature `extractRecoveredAccountFromRecoveryCommand(bytes[],uint256)` and selector `0xa5e3ee70`
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
        name = "extractRecoveredAccountFromRecoveryCommand",
        abi = "extractRecoveredAccountFromRecoveryCommand(bytes[],uint256)"
    )]
    pub struct ExtractRecoveredAccountFromRecoveryCommandCall {
        pub command_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
        pub template_idx: ::ethers::core::types::U256,
    }
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
    ///Container type for all input parameters for the `isActivated` function with signature `isActivated(address)` and selector `0xc9faa7c5`
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
    #[ethcall(name = "isActivated", abi = "isActivated(address)")]
    pub struct IsActivatedCall {
        pub recovered_account: ::ethers::core::types::Address,
    }
    ///Container type for all input parameters for the `recoveryCommandTemplates` function with signature `recoveryCommandTemplates()` and selector `0x3ef01b8f`
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
    #[ethcall(name = "recoveryCommandTemplates", abi = "recoveryCommandTemplates()")]
    pub struct RecoveryCommandTemplatesCall;
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
    pub enum EmailAccountRecoveryCalls {
        AcceptanceCommandTemplates(AcceptanceCommandTemplatesCall),
        CompleteRecovery(CompleteRecoveryCall),
        ComputeAcceptanceTemplateId(ComputeAcceptanceTemplateIdCall),
        ComputeEmailAuthAddress(ComputeEmailAuthAddressCall),
        ComputeRecoveryTemplateId(ComputeRecoveryTemplateIdCall),
        Dkim(DkimCall),
        DkimAddr(DkimAddrCall),
        EmailAuthImplementation(EmailAuthImplementationCall),
        EmailAuthImplementationAddr(EmailAuthImplementationAddrCall),
        ExtractRecoveredAccountFromAcceptanceCommand(
            ExtractRecoveredAccountFromAcceptanceCommandCall,
        ),
        ExtractRecoveredAccountFromRecoveryCommand(
            ExtractRecoveredAccountFromRecoveryCommandCall,
        ),
        HandleAcceptance(HandleAcceptanceCall),
        HandleRecovery(HandleRecoveryCall),
        IsActivated(IsActivatedCall),
        RecoveryCommandTemplates(RecoveryCommandTemplatesCall),
        Verifier(VerifierCall),
        VerifierAddr(VerifierAddrCall),
    }
    impl ::ethers::core::abi::AbiDecode for EmailAccountRecoveryCalls {
        fn decode(
            data: impl AsRef<[u8]>,
        ) -> ::core::result::Result<Self, ::ethers::core::abi::AbiError> {
            let data = data.as_ref();
            if let Ok(decoded) = <AcceptanceCommandTemplatesCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::AcceptanceCommandTemplates(decoded));
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
            if let Ok(decoded) = <ExtractRecoveredAccountFromAcceptanceCommandCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ExtractRecoveredAccountFromAcceptanceCommand(decoded));
            }
            if let Ok(decoded) = <ExtractRecoveredAccountFromRecoveryCommandCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::ExtractRecoveredAccountFromRecoveryCommand(decoded));
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
            if let Ok(decoded) = <IsActivatedCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::IsActivated(decoded));
            }
            if let Ok(decoded) = <RecoveryCommandTemplatesCall as ::ethers::core::abi::AbiDecode>::decode(
                data,
            ) {
                return Ok(Self::RecoveryCommandTemplates(decoded));
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
    impl ::ethers::core::abi::AbiEncode for EmailAccountRecoveryCalls {
        fn encode(self) -> Vec<u8> {
            match self {
                Self::AcceptanceCommandTemplates(element) => {
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
                Self::ExtractRecoveredAccountFromAcceptanceCommand(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::ExtractRecoveredAccountFromRecoveryCommand(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::HandleAcceptance(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::HandleRecovery(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::IsActivated(element) => {
                    ::ethers::core::abi::AbiEncode::encode(element)
                }
                Self::RecoveryCommandTemplates(element) => {
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
    impl ::core::fmt::Display for EmailAccountRecoveryCalls {
        fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
            match self {
                Self::AcceptanceCommandTemplates(element) => {
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
                Self::ExtractRecoveredAccountFromAcceptanceCommand(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::ExtractRecoveredAccountFromRecoveryCommand(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::HandleAcceptance(element) => ::core::fmt::Display::fmt(element, f),
                Self::HandleRecovery(element) => ::core::fmt::Display::fmt(element, f),
                Self::IsActivated(element) => ::core::fmt::Display::fmt(element, f),
                Self::RecoveryCommandTemplates(element) => {
                    ::core::fmt::Display::fmt(element, f)
                }
                Self::Verifier(element) => ::core::fmt::Display::fmt(element, f),
                Self::VerifierAddr(element) => ::core::fmt::Display::fmt(element, f),
            }
        }
    }
    impl ::core::convert::From<AcceptanceCommandTemplatesCall>
    for EmailAccountRecoveryCalls {
        fn from(value: AcceptanceCommandTemplatesCall) -> Self {
            Self::AcceptanceCommandTemplates(value)
        }
    }
    impl ::core::convert::From<CompleteRecoveryCall> for EmailAccountRecoveryCalls {
        fn from(value: CompleteRecoveryCall) -> Self {
            Self::CompleteRecovery(value)
        }
    }
    impl ::core::convert::From<ComputeAcceptanceTemplateIdCall>
    for EmailAccountRecoveryCalls {
        fn from(value: ComputeAcceptanceTemplateIdCall) -> Self {
            Self::ComputeAcceptanceTemplateId(value)
        }
    }
    impl ::core::convert::From<ComputeEmailAuthAddressCall>
    for EmailAccountRecoveryCalls {
        fn from(value: ComputeEmailAuthAddressCall) -> Self {
            Self::ComputeEmailAuthAddress(value)
        }
    }
    impl ::core::convert::From<ComputeRecoveryTemplateIdCall>
    for EmailAccountRecoveryCalls {
        fn from(value: ComputeRecoveryTemplateIdCall) -> Self {
            Self::ComputeRecoveryTemplateId(value)
        }
    }
    impl ::core::convert::From<DkimCall> for EmailAccountRecoveryCalls {
        fn from(value: DkimCall) -> Self {
            Self::Dkim(value)
        }
    }
    impl ::core::convert::From<DkimAddrCall> for EmailAccountRecoveryCalls {
        fn from(value: DkimAddrCall) -> Self {
            Self::DkimAddr(value)
        }
    }
    impl ::core::convert::From<EmailAuthImplementationCall>
    for EmailAccountRecoveryCalls {
        fn from(value: EmailAuthImplementationCall) -> Self {
            Self::EmailAuthImplementation(value)
        }
    }
    impl ::core::convert::From<EmailAuthImplementationAddrCall>
    for EmailAccountRecoveryCalls {
        fn from(value: EmailAuthImplementationAddrCall) -> Self {
            Self::EmailAuthImplementationAddr(value)
        }
    }
    impl ::core::convert::From<ExtractRecoveredAccountFromAcceptanceCommandCall>
    for EmailAccountRecoveryCalls {
        fn from(value: ExtractRecoveredAccountFromAcceptanceCommandCall) -> Self {
            Self::ExtractRecoveredAccountFromAcceptanceCommand(value)
        }
    }
    impl ::core::convert::From<ExtractRecoveredAccountFromRecoveryCommandCall>
    for EmailAccountRecoveryCalls {
        fn from(value: ExtractRecoveredAccountFromRecoveryCommandCall) -> Self {
            Self::ExtractRecoveredAccountFromRecoveryCommand(value)
        }
    }
    impl ::core::convert::From<HandleAcceptanceCall> for EmailAccountRecoveryCalls {
        fn from(value: HandleAcceptanceCall) -> Self {
            Self::HandleAcceptance(value)
        }
    }
    impl ::core::convert::From<HandleRecoveryCall> for EmailAccountRecoveryCalls {
        fn from(value: HandleRecoveryCall) -> Self {
            Self::HandleRecovery(value)
        }
    }
    impl ::core::convert::From<IsActivatedCall> for EmailAccountRecoveryCalls {
        fn from(value: IsActivatedCall) -> Self {
            Self::IsActivated(value)
        }
    }
    impl ::core::convert::From<RecoveryCommandTemplatesCall>
    for EmailAccountRecoveryCalls {
        fn from(value: RecoveryCommandTemplatesCall) -> Self {
            Self::RecoveryCommandTemplates(value)
        }
    }
    impl ::core::convert::From<VerifierCall> for EmailAccountRecoveryCalls {
        fn from(value: VerifierCall) -> Self {
            Self::Verifier(value)
        }
    }
    impl ::core::convert::From<VerifierAddrCall> for EmailAccountRecoveryCalls {
        fn from(value: VerifierAddrCall) -> Self {
            Self::VerifierAddr(value)
        }
    }
    ///Container type for all return fields from the `acceptanceCommandTemplates` function with signature `acceptanceCommandTemplates()` and selector `0x222f6cb5`
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
    pub struct AcceptanceCommandTemplatesReturn(
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
    ///Container type for all return fields from the `computeEmailAuthAddress` function with signature `computeEmailAuthAddress(address,bytes32)` and selector `0x3a8eab14`
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
    ///Container type for all return fields from the `extractRecoveredAccountFromAcceptanceCommand` function with signature `extractRecoveredAccountFromAcceptanceCommand(bytes[],uint256)` and selector `0x2c4ce129`
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
    pub struct ExtractRecoveredAccountFromAcceptanceCommandReturn(
        pub ::ethers::core::types::Address,
    );
    ///Container type for all return fields from the `extractRecoveredAccountFromRecoveryCommand` function with signature `extractRecoveredAccountFromRecoveryCommand(bytes[],uint256)` and selector `0xa5e3ee70`
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
    pub struct ExtractRecoveredAccountFromRecoveryCommandReturn(
        pub ::ethers::core::types::Address,
    );
    ///Container type for all return fields from the `isActivated` function with signature `isActivated(address)` and selector `0xc9faa7c5`
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
    pub struct IsActivatedReturn(pub bool);
    ///Container type for all return fields from the `recoveryCommandTemplates` function with signature `recoveryCommandTemplates()` and selector `0x3ef01b8f`
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
    pub struct RecoveryCommandTemplatesReturn(
        pub ::std::vec::Vec<::std::vec::Vec<::std::string::String>>,
    );
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
        pub command_params: ::std::vec::Vec<::ethers::core::types::Bytes>,
        pub skipped_command_prefix: ::ethers::core::types::U256,
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
        pub masked_command: ::std::string::String,
        pub email_nullifier: [u8; 32],
        pub account_salt: [u8; 32],
        pub is_code_exist: bool,
        pub proof: ::ethers::core::types::Bytes,
    }
}
