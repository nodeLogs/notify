// File: @openzeppelin\contracts\math\SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin\contracts\token\ERC20\IERC20.sol


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin\contracts\utils\Address.sol


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @openzeppelin\contracts\GSN\Context.sol


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin\contracts\utils\Pausable.sol


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: @openzeppelin\contracts\utils\ReentrancyGuard.sol


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin\contracts\access\Ownable.sol


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts\BridgeOnSeele.sol

pragma experimental ABIEncoderV2;

contract SeeleBridge is Pausable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bytes32 public state_lastValsetCheckpoint;
    uint256 public state_powerThreshold;

    uint256 public constant TX_EVENT_WAIT  = 0;
    uint256 public constant TX_EVENT_DEAL  = 1;
    uint256 public constant TX_EVENT_REFUSE = 2;
    uint256 public constant TX_EVENT_PUNISH = 3;
    // Info of each TX Event.
    struct TxEvent {
        uint256 eventNonce; 
        address sender;
        address destination;
        address tokenContract;
        uint256 amount;
        uint256 status;
    }

    mapping(uint256 => TxEvent) public txEvents;

    uint256 public state_lastValsetNonce = 0;
    // value indicating that no events have yet been submitted
    uint256 public state_lastEventNonce = 1;

    mapping(address => bool) private _seeleTokenWhiteList;
    mapping(address => uint256) public seeleTokenMinAmountList; // min amount to deposit

    // fee 0.002
    uint256 public Fee = 2;
    address public FeeWallet;

    event WhiteListUpdateEvent(address _token, bool _value);

    event SendToEthEvent(
        address indexed _tokenContract,
        address indexed _sender,
        address indexed _destination,
        uint256 _amount,
        uint256 _eventNonce
    );

    event ValsetUpdatedEvent(
        uint256 indexed _newValsetNonce,
        address[] _validators,
        uint256[] _powers
    );

    event SendToEthUpdateEvent(
        address indexed _tokenContract,
        address indexed _sender,
        address indexed _destination,
        uint256 _amount,
        uint256 _eventNonce,
        uint256 _status
    );

    constructor() public {
        FeeWallet = msg.sender;
        _seeleTokenWhiteList[address(0)] = true;
    }

    function setFee(uint256 _fee) public onlyOwner {
        Fee = _fee;
    }

    function setFeeWallet(address _feeWallet) public onlyOwner{
        FeeWallet = _feeWallet;
    }

    function initialize(
        // How much voting power is needed to approve operations
        uint256 _powerThreshold,
        // The validator set, not in valset args format since many of it's
        // arguments would never be used in this case
        address[] calldata _validators,
        uint256[] memory _powers
    ) external onlyOwner {
        require(
            _validators.length == _powers.length,
            "Malformed current validator set"
        );

        // Check cumulative power to ensure the contract has sufficient power to actually
        // pass a vote
        uint256 cumulativePower = 0;
        for (uint256 i = 0; i < _powers.length; i++) {
            cumulativePower = cumulativePower + _powers[i];
            if (cumulativePower > _powerThreshold) {
                break;
            }
        }

        require(
            cumulativePower > _powerThreshold,
            "Submitted validator set signatures do not have enough power."
        );

        bytes32 newCheckpoint = makeCheckpoint(
            _validators,
            _powers,
            state_lastValsetNonce
        );

        state_powerThreshold = _powerThreshold;
        state_lastValsetCheckpoint = newCheckpoint;

        emit ValsetUpdatedEvent(
            state_lastValsetNonce,
            _validators,
            _powers
        );
    }

    function updateValset(
        // The new version of the validator set
        address[] memory _newValidators,
        uint256[] memory _newPowers,

        // The current validators that approve the change
        address[] memory _currentValidators,
        uint256[] memory _currentPowers,
        // These are arrays of the parts of the current validator's signatures
        uint8[] memory _v,
        bytes32[] memory _r,
        bytes32[] memory _s
    ) external onlyOwner whenNotPaused nonReentrant {
        // Check that new validators and powers set is well-formed
        require(
            _newValidators.length == _newPowers.length,
            "Malformed new validator set"
        );

        // Check that current validators, powers, and signatures (v,r,s) set is well-formed
        require(
            _currentValidators.length == _currentPowers.length &&
                _currentValidators.length == _v.length &&
                _currentValidators.length == _r.length &&
                _currentValidators.length == _s.length,
            "Malformed current validator set"
        );

        
        // Check that the supplied current validator set matches the saved checkpoint
        require(
            makeCheckpoint(
                _currentValidators,
                _currentPowers,
                state_lastValsetNonce
            ) == state_lastValsetCheckpoint,
            "Supplied current validators and powers do not match checkpoint."
        );


        state_lastValsetNonce = state_lastValsetNonce.add(1);
        // Check that enough current validators have signed off on the new validator set
        bytes32 newCheckpoint = makeCheckpoint(
            _newValidators,
            _newPowers,
            state_lastValsetNonce
        );

        checkValidatorSignatures(
            _currentValidators,
            _currentPowers,
            _v,
            _r,
            _s,
            newCheckpoint,
            state_powerThreshold
        );

        state_lastValsetCheckpoint = newCheckpoint;

        emit ValsetUpdatedEvent(
            state_lastValsetNonce,
            _newValidators,
            _newPowers
        );
    }

    // Utility function to verify geth style signatures
    function verifySig(
        address _signer,
        bytes32 _theHash,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) private pure returns (bool) {
        bytes32 messageDigest = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _theHash)
        );
        return _signer == ecrecover(messageDigest, _v, _r, _s);
    }

    function makeCheckpoint(
        address[] memory _validators,
        uint256[] memory _powers,
        uint256 _valsetNonce
    ) private pure returns (bytes32) {
        // bytes32 encoding of the string "checkpoint"
        bytes32 methodName = 0x636865636b706f696e7400000000000000000000000000000000000000000000;

        bytes32 checkpoint = keccak256(
            abi.encode(
                methodName,
                _valsetNonce,
                _validators,
                _powers
            )
        );

        return checkpoint;
    }

    function checkValidatorSignatures(
        // The current validator set and their powers
        address[] memory _currentValidators,
        uint256[] memory _currentPowers,
        // The current validator's signatures
        uint8[] memory _v,
        bytes32[] memory _r,
        bytes32[] memory _s,
        // This is what we are checking they have signed
        bytes32 _theHash,
        uint256 _powerThreshold
    ) private pure {
        uint256 cumulativePower = 0;

        for (uint256 i = 0; i < _currentValidators.length; i++) {
            // If v is set to 0, this signifies that it was not possible to get a signature from this validator and we skip evaluation
            // (In a valid signature, it is either 27 or 28)
            if (_v[i] != 0) {
                // Check that the current validator has signed off on the hash
                require(
                    verifySig(
                        _currentValidators[i],
                        _theHash,
                        _v[i],
                        _r[i],
                        _s[i]
                    ),
                    "Validator signature does not match."
                );

                // Sum up cumulative power
                cumulativePower = cumulativePower + _currentPowers[i];

                // Break early to avoid wasting gas
                if (cumulativePower > _powerThreshold) {
                    break;
                }
            }
        }

        // Check that there was enough power
        require(
            cumulativePower > _powerThreshold,
            "Submitted validator set signatures do not have enough power."
        );
        // Success
    }

    function sendToEth(
        address _tokenContract,
        address _destination,
        uint256 _amount
    )
        external
        payable
        onlySeeleTokenWhiteList(_tokenContract)
        whenNotPaused
        nonReentrant
    {
        uint256 minAmount = seeleTokenMinAmountList[_tokenContract];
        if (msg.value > 0) {
            // Seele deposit
            require(_tokenContract == address(0), "!address(0)");
            require(msg.value == _amount, "incorrect seele amount");
            require(msg.value >= minAmount, "seele msg.value < minAmount");
        } else {
            require(_amount >= minAmount, "token amount < minAmount");
            // ERC20 deposit
            IERC20(_tokenContract).safeTransferFrom(
                msg.sender,
                address(this),
                _amount
            );
        }

        TxEvent storage txevent = txEvents[state_lastEventNonce];
        txevent.eventNonce = state_lastEventNonce;
        txevent.sender = msg.sender;
        txevent.destination = _destination;
        txevent.tokenContract = _tokenContract;
        txevent.amount = _amount;
        txevent.status = TX_EVENT_WAIT;

        emit SendToEthEvent(
            _tokenContract,
            msg.sender,
            _destination,
            _amount,
            state_lastEventNonce
        );

        state_lastEventNonce = state_lastEventNonce.add(1);
    }

    function submitResult(
         address[] memory _currentValidators,
         uint256[] memory _currentPowers,
         uint8[] memory _v,
         bytes32[] memory _r,
         bytes32[] memory _s,
         uint256 eventNonce,
         uint256    result
    )external nonReentrant whenNotPaused{
        require( result > 0 && result <= TX_EVENT_PUNISH,"Malformed current result set");

        // Check that current validators, powers, and signatures (v,r,s) set is well-formed
        require(
            _currentValidators.length == _currentPowers.length &&
                _currentValidators.length == _v.length &&
                _currentValidators.length == _r.length &&
                _currentValidators.length == _s.length,
            "Malformed current validator set"
        );

        // Check that the supplied current validator set matches the saved checkpoint
        require(
            makeCheckpoint(
                _currentValidators,
                _currentPowers,
                state_lastValsetNonce
            ) == state_lastValsetCheckpoint,
            "Supplied current validators and powers do not match checkpoint."
        );

        // Check that enough current validators have signed off on the transaction batch and valset
        checkValidatorSignatures(
            _currentValidators,
            _currentPowers,
            _v,
            _r,
            _s,
            // Get hash of the transaction batch and checkpoint
            keccak256(
                abi.encode(
                    eventNonce,
                    // bytes32 encoding of "checkpoint"
                    0x636865636b706f696e7400000000000000000000000000000000000000000000,
                    result
                )
            ),
            state_powerThreshold
        );

        // ACTIONS
        TxEvent storage txevent = txEvents[eventNonce];
        require(txevent.eventNonce > 0, " nonce must > 0");
        require(txevent.status == TX_EVENT_WAIT, "status must be TX_EVENT_WAIT");

        txevent.status = result;
        
        if(result==TX_EVENT_REFUSE){
            if (txevent.tokenContract == address(0)) {
                // seele deposit
                address payable wallet = payable(txevent.sender);
                wallet.transfer(txevent.amount);
            } else {
                // ERC20 deposit
                IERC20(txevent.tokenContract).transfer(
                    txevent.sender,
                    txevent.amount
                );
            }
        }

        uint256 minAmount = seeleTokenMinAmountList[txevent.tokenContract];
        if(result==TX_EVENT_DEAL){
            if (txevent.tokenContract == address(0)) {
                // seele deposit
                if (Fee>0||minAmount>0){
                     address payable wallet = payable(address(0x00dead));
                     address payable walletFee = payable(FeeWallet);
                     uint256 feeAmount = minAmount;
                     if(txevent.amount.mul(Fee).div(1000)>minAmount){
                         feeAmount =  txevent.amount.mul(Fee).div(1000);
                     }
                     walletFee.transfer(feeAmount);
                     wallet.transfer(txevent.amount.sub(feeAmount));
                     
                }else{
                    address payable wallet = payable(address(0x00dead));
                    wallet.transfer(txevent.amount);
                }
                
            } else {
                // ERC20 deposit
                if (Fee>0||minAmount>0){
                    uint256 feeAmount = minAmount;
                     if(txevent.amount.mul(Fee).div(1000)>minAmount){
                         feeAmount =  txevent.amount.mul(Fee).div(1000);
                     }
                     IERC20(txevent.tokenContract).transfer(
                        FeeWallet,
                        feeAmount
                    );
                    IERC20(txevent.tokenContract).transfer(
                        address(0x00dead),
                        txevent.amount.sub(feeAmount)
                    );
                    
                }else{
                    IERC20(txevent.tokenContract).transfer(
                        address(0x00dead),
                        txevent.amount
                    );
                }
            }
        }

        if(result== TX_EVENT_PUNISH){
            if (txevent.tokenContract == address(0)) {
                address payable wallet = payable(FeeWallet);
                wallet.transfer(txevent.amount);
            }else{
                IERC20(txevent.tokenContract).transfer(
                    FeeWallet,
                    txevent.amount
                );
            }
        }

        emit SendToEthUpdateEvent(
            txevent.tokenContract,
            txevent.sender,
            txevent.destination,
            txevent.amount,
            txevent.eventNonce,
            txevent.status
        );
    }

     /*
     * @dev: Modifier to restrict erc20 can be locked
     */
    modifier onlySeeleTokenWhiteList(address _token) {
        require(
            getTokenInWhiteList(_token),
            "Only token in whitelist can be transferred to eth"
        );
        _;
    }

    /*
     * @dev: Set the token address in whitelist
     *
     * @param _token: ERC 20's address
     * @param _inList: set the _token in list or not
     */
    function setTokenInEthWhiteList(address _token, bool _inList)
        external
        onlyOwner
    {
        _seeleTokenWhiteList[_token] = _inList;
        emit WhiteListUpdateEvent(_token, _inList);
    }
     /*
     * @dev: Get if the token in whitelist
     *
     * @param _token: ERC 20's address
     * @return: if _token in whitelist
     */
    function getTokenInWhiteList(address _token) public view returns (bool) {
        return _seeleTokenWhiteList[_token];
    }

    function setTokenMinAmountList(address _token, uint256 _minAmount)
        external
        onlyOwner
    {
        seeleTokenMinAmountList[_token] = _minAmount;

    }

    function getTokenMinAmountList(address _token) public view returns (uint256) {
        return seeleTokenMinAmountList[_token];
    }

    function pause() public onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() public onlyOwner whenPaused {
        _unpause();
    }
}
