// SPDX-License-Identifier: BSL-1.1
pragma solidity 0.8.25;

import "forge-std/Test.sol";
import {stdStorage, StdStorage} from "forge-std/Test.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
import "forge-std/Script.sol";
import "forge-std/Base.sol";
import "forge-std/Vm.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

import "../../src/Vault.sol";
import "../../src/VaultConfigurator.sol";
import "../../src/validators/AllowAllValidator.sol";
import "../../src/validators/ManagedValidator.sol";
import "../../src/validators/ERC20SwapValidator.sol";
import "../../src/utils/DefaultAccessControl.sol";
import "../../src/utils/DepositWrapper.sol";
import "../../src/strategies/SimpleDVTStakingStrategy.sol";
import "../../src/oracles/ChainlinkOracle.sol";
import "../../src/oracles/ManagedRatiosOracle.sol";
import "../../src/oracles/ConstantAggregatorV3.sol";
import "../../src/oracles/WStethRatiosAggregatorV3.sol";
import "../../src/modules/erc20/ERC20TvlModule.sol";
import "../../src/modules/erc20/ERC20SwapModule.sol";
import "../../src/modules/erc20/ManagedTvlModule.sol";
import "../../src/modules/obol/StakingModule.sol";

import "../../src/modules/obol/StakingModule.sol";

import "../../src/libraries/external/FullMath.sol";

import "../../src/interfaces/external/lido/ISteth.sol";
import "../../src/interfaces/external/lido/IWSteth.sol";
import "../../src/interfaces/external/lido/IStakingRouter.sol";
import "../../src/interfaces/external/lido/IDepositContract.sol";
import "../../src/interfaces/external/uniswap/ISwapRouter.sol";

import "../../src/security/AdminProxy.sol";
import "../../src/security/DefaultProxyImplementation.sol";
import "../../src/security/Initializer.sol";

import "../../src/utils/RestrictingKeeper.sol";

import "./DeployConstants.sol";

interface DeployInterfaces {
    struct DeployParameters {
        address deployer;
        address proxyAdmin;
        address admin;
        address curatorAdmin;
        address curatorOperator;
        address wsteth;
        address steth;
        address weth;
        uint256 maximalTotalSupply;
        string lpTokenName;
        string lpTokenSymbol;
        uint256 initialDepositETH;
        uint256 firstDepositETH;
        Vault initialImplementation;
        Initializer initializer;
        ERC20TvlModule erc20TvlModule;
        StakingModule stakingModule;
        ManagedRatiosOracle ratiosOracle;
        ChainlinkOracle priceOracle;
        IAggregatorV3 wethAggregatorV3;
        IAggregatorV3 wstethAggregatorV3;
        DefaultProxyImplementation defaultProxyImplementation;
    }

    struct DeploySetup {
        Vault vault; // TransparantUpgradeableProxy
        ProxyAdmin proxyAdmin;
        IVaultConfigurator configurator;
        ManagedValidator validator;
        SimpleDVTStakingStrategy strategy;
        DepositWrapper depositWrapper;
        uint256 wstethAmountDeposited;
    }
}
