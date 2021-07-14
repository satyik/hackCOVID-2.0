// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract MedProduct {
  struct ret
    {
        address retId;
        string name;
        string medDesc;
    }
    struct medicine 
    {
        uint256 medId;
        string manuDate;
        string medName;
        string expiry;
        string mrp;
        uint256 numRetail;
        mapping(uint256=>ret) del;
        address manufacturer;
    }
    event TaskCreated(
        uint256 meds
    );
    mapping(uint256=>medicine) public medProd;
    uint256 meds= 12345;
    function newMed(string memory _medName,string memory _mrp,string memory _expiry,string memory _manuDate) public 
    {
        medProd[meds].medId=meds;
        medProd[meds].manuDate=_manuDate;
        medProd[meds].medName=_medName;
        medProd[meds].mrp=_mrp;
        medProd[meds].expiry= _expiry;
        
        meds++;
        emit TaskCreated(meds-1);
    }
    function concatenate(string memory _a,string memory _b) pure internal returns(string memory)
    {
        bytes memory a=bytes(_a);
        bytes memory b=bytes(_b);
        string memory ab=new string(a.length+b.length);
        bytes memory c=bytes(ab);
        uint256 k=0;
        for(uint256 i=0;i<a.length;i++)c[k++]=a[i];
        for(uint256 i=0;i<b.length;i++)c[k++]=b[i];
        return string(c);
    }
    function addret(uint256 _medId,string memory _date,string memory _loc,string memory _name) public returns(string memory)
    {
        string memory description="DATE: ";
        description=concatenate(description,_date);
        description=concatenate(description,"\n");
        string memory location="LOCATION: ";
        description=concatenate(description,location);
        description=concatenate(description,_loc);
        description=concatenate(description,"\n");
        string memory name="NAME: ";
        description=concatenate(description,name);
        description=concatenate(description,_name);
        ret memory newRetail=ret({retId:msg.sender,medDesc:description,name:_name});
        medProd[_medId].del[medProd[_medId].numRetail]=newRetail;
        medProd[_medId].numRetail++;
        return description;
    }
    function medInfo(uint256 _medId) view public returns(string memory)
    {
        string memory info="Medicine name: ";
        info=concatenate(info,medProd[_medId].medName);
        info=concatenate(info,"\n");
        info=concatenate(info,"MRP: ");
        info=concatenate(info,medProd[_medId].mrp);
        info=concatenate(info,"\n");
        info=concatenate(info,"Manufacture Date: ");
        info=concatenate(info,medProd[_medId].manuDate);
        info=concatenate(info,"\n");
        info=concatenate(info,"Expiry: ");
        info=concatenate(info,medProd[_medId].expiry);
        info=concatenate(info,"\n");
        info=concatenate(info,"\n");
        info=concatenate(info,"Retailers Details \n");
        for(uint256 i=0;i<medProd[_medId].numRetail;i++)
        {
            info=concatenate(info,"\n");
            info=concatenate(info,"\n");
            info=concatenate(info,medProd[_medId].del[i].medDesc);
        }
        return info;
    }
}