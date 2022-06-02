// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReferralSystem {
    // a => b i.e. a was referred by b
    mapping (string => string) refs;
    // a => b i.e. list of all referrals by a
    mapping (string => string[]) referralIds;

    function addReferral(string calldata _refereeId, string calldata _referredId) public {
        // check if referral is already referred
        if (contains(_referredId)) {
            return;
        } else {
            refs[_referredId] = _refereeId;
            referralIds[_refereeId].push(_referredId);
        }
    }

    function getReferralsCount(string calldata _refereeId) public view returns(uint) {
        return referralIds[_refereeId].length;
    }

    function getReferrals(string calldata _refereeId) public view returns(string[] memory) {
        return referralIds[_refereeId];
    }

    function getReferee(string calldata _referredId) public view returns(string memory) {
        return refs[_referredId];
    }

    function contains(string calldata _id) private view returns(bool) {
        if (bytes(refs[_id]).length > 0) {
            return true;
        } else {
            return false;
        }
    }
}
