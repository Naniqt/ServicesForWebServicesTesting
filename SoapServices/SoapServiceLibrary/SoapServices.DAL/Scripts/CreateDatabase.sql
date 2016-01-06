﻿DROP PROCEDURE IF EXISTS `_idempotent_script`;

DELIMITER //

CREATE PROCEDURE `_idempotent_script`()
BEGIN
  DECLARE CurrentMigration TEXT;

  IF EXISTS(SELECT 1 FROM information_schema.tables 
  WHERE table_name = '__MigrationHistory' 
  AND table_schema = DATABASE()) THEN 
    SET CurrentMigration = (SELECT
`Project1`.`MigrationId`
FROM `__MigrationHistory` AS `Project1`
 WHERE `Project1`.`ContextKey` = 'SoapServices.DAL.Migrations.Configuration'
 ORDER BY 
`Project1`.`MigrationId` DESC LIMIT 1);
  END IF;

  IF CurrentMigration IS NULL THEN
    SET CurrentMigration = '0';
  END IF;

  IF CurrentMigration < '201601050632479_First' THEN 
create table `Address` (`Id` int not null  auto_increment ,`StreetLine1` longtext,`StreetLine2` longtext,`City` longtext,`State` longtext,`Country` longtext,primary key ( `Id`) ) engine=InnoDb auto_increment=0;
create table `ContactInfo` (`Id` int not null  auto_increment ,`PrimaryContactNumber` longtext not null ,`SecondaryContactNumber` longtext,`EmailId` longtext not null ,`SkypeId` longtext,`LinkedInId` longtext,`FacebookId` longtext,primary key ( `Id`) ) engine=InnoDb auto_increment=0;
create table `Course` (`CourseId` int not null  auto_increment ,`CourseName` longtext,`CourseContents` longtext,primary key ( `CourseId`) ) engine=InnoDb auto_increment=0;
create table `Student` (`Id` int not null  auto_increment ,`Name` longtext not null ,`FathersName` longtext not null ,`ContactId` int not null ,`AddressId` int not null ,primary key ( `Id`) ) engine=InnoDb auto_increment=0;
CREATE index  `IX_ContactId` on `Student` (`ContactId` DESC) using HASH;
CREATE index  `IX_AddressId` on `Student` (`AddressId` DESC) using HASH;
alter table `Student` add constraint `FK_Student_Address_AddressId`  foreign key (`AddressId`) references `Address` ( `Id`)  on update cascade on delete cascade ;
alter table `Student` add constraint `FK_Student_ContactInfo_ContactId`  foreign key (`ContactId`) references `ContactInfo` ( `Id`)  on update cascade on delete cascade ;
create table `__MigrationHistory` (`MigrationId` nvarchar(150)  not null ,`ContextKey` nvarchar(300)  not null ,`Model` longblob not null ,`ProductVersion` nvarchar(32)  not null ,primary key ( `MigrationId`,`ContextKey`) ) engine=InnoDb auto_increment=0;
INSERT INTO `__MigrationHistory`(
`MigrationId`, 
`ContextKey`, 
`Model`, 
`ProductVersion`) VALUES (
'201601050632479_First', 
'SoapServices.DAL.Migrations.Configuration', 
0x1F8B0800000000000400ED5BDB6EE336107D2FD07F10F45864AD248BA26D60EF22759222686E889345DF16B4443B44284A15A920C6A25FD6877E527FA143DD4C89D435B6932E16FBE2F07266383C1C0D67B8FFFEFDCFF8E3B34FAD271C7112B0897D30DAB72DCCDCC0236C39B163B178F7B3FDF1C3F7DF8D4F3DFFD9FA948F7B2FC7C14CC627F68310E191E370F701FB888F7CE246010F1662E406BE83BCC039DCDFFFC53938703040D8806559E3DB9809E2E3E40FF8731A3017872246F432F030E5593BF4CC1254EB0AF99887C8C5137B16A07086A327E2623E3A39BE189D7AB18B04A885E839E3828858FE615BC79420506F86E9C2B610638148461DDD733C1351C096B3101A10BD5B8518C62D10E5385BD4D17A78D7F5ED1FCAF539EB8939941B7311F83D010FDE670673AAD30799DD2E0C0A263D05D38B955C7562D6897DEC7911E6DCB6AAB28EA63492E33A1B7D9441ED59D5097B05778062F2DF9E358DA988233C61381611A27BD64D3CA7C4FD1DAFEE8247CC262CA654551C5487BE520334DD44418823B1BAC58B6C39E79E6D39E5794E7562314D9993AEF49C89F787B67505C2D19CE282178A55662288F06F98E10809ECDD202170C424064E2CAB49AFC802F2612C2E08C307B9506882F3665B97E8F902B3A57898D8F0D3B6CEC833F6F2964C917B46E078C22411C5B8BBACC3ADCB9A266BDFFA82C0E6DB5F4A00FE29DAF46AC6CEFAE8351E48708702B9E29C2D82C8CF4EFDCBCFA68EFAED9836C8BA89888FA25566B5ABD89FE3680384D0346EE13B7603E66D418F66B1A73E22746DED1DAEF711046E4470B31C70898FD83B673B10750661CB3C081E372EAA873F892389B5091F22915ED56FA42A0CF11EEB99BBF221A944F97B179F2C1025BD04A8C65F8B6933114BD36C826A19D4B76F5483AC0D31ABA78F3E43E20176E07584E7514CAB959B61B28B4A6F982BF44496C9DE99016DEB16D3A49F3F9030BD7DE654FE5C8C398B02FF36A0EB0393777D9EC13176A5590373FF1D8A965874574B09FA1A552B8DD3D553BA6B5554C798D4AC7322C79C072E49142B7B91C25EE5B59E32CF6A315ECA49657DC04C70112404A7001A4CEC1F340BD6A3E66B51508B8D2CA31ED8559772CD4E30C5025BC76E7AF79F22EE224FE715D8C62BB78017C291740388826539F835C284EEB20873498868B3EE95691D7D9D54AB1050ED39C121665256F35E7491AC9C455D81424EC55E6DE6193B0AAFBAD14D3D036DE4301E888DD0CE748C1464D3DDF0ADB2D0B0941D32D1B0455DA42B1F981DB0317589894C0251407EFD32864427F324BC7B368557F710FBA51116CF3EAC559E4939332CCA670E830F5B7BE5AA77D3B85AC6D0A968423311B61558C6B266B0F426D3029051C084509CCC0A84B23F1ACEFAC3AD8CAAF9B65729D3FEB52A9457F5D6A8D7FE7D527094DDAD9EF0F23A7BD8A01421D4DBA1D6897676A343ED61729C0A9691AD9DAD93072FC5495D97289CB44691D7329C9A62C6F812852104C94A71236BB166696563FA6ED63FBBEFA7188ECB0D49FE42DB4212DC37D012577AA5713C7C46222E4E904073248FD8D4F3B5616D7EA9E654E6D2ABAE47DFD3FCB0E633E4EF8C86FD2A1006579F619E81017CF9B548EE5EFAA1D167266528445164B8E94D031AFBACFEBB553FBB540650614A1D43F00EEBF00EFBE0A5E97C15686AB891366B94E4EACBBA244D3DB4C833F12545F2461D67EC54B659FB846B24D342A0326B3B71DAE45CB6C16EC3C7B43FD1BB806C87F3E69CBA8A671ED1837335F9F212096BC6749752A4C755D8A2B187B679B6BBA45EDED81D47CD66AB506A7B77343561ADA2A9ED6FE8E4A5B1E2764E5B126D0E3961E6890D5E2ECB4C57DC9C31D3DD8E94A6E674ACB4BD2FDA3AA9AC23AEFBDE0C238AA0711B94C8AF0FFD39513B733BAE56A740DFCD2FA579CB7E40E9E843A6E2625DE651ED7DBB1E4B4919A9580D99A42DD351BB1F548714D28B7B42E53E30CE62F3F617505AB09E0EB12D30D213F164A07EB99AFD4947B27F94FC9C52925C7AF31197889105E6222D8FD83F8E7EAABC977A3B6F971CCE3DDAED01D3CE2B3C44DAB4B586D3B704AEBF0FA2015BA6899F35D6C0E73F43A1D4D73DC3D5511EEF0C56A4FC36A71BCC4B9EDE7C1DAC6A7ACE62B2E1065EA70CDDE1CAE393E1DA95DF920C55477F2A3214497F09B271F6EA71E7AE5F556C85BDFA438A17B80FC33B890DEF8331D6FBDFBA8E36B30F7D3430184B7B03408C4F4ECE99879F27F69764D69175FE479122F6F6ACEB08C2A0236BDFFAEBE56F07BA8A2F26F610BFF9AA7951CCD871415BCBD80FAB980EAA48D66785B7557EFCEA2ADFA63ADEEBD5A55F934C9D92B0AFCAABB750C3D64B4A35D99BEA03AAFA7A747ACF9DD8DE3C80ED4E5DE6F06275C75AB54968A916DAA998DD50CB360BE853E76E2A739BD05FAF065ED9E452DDAD438DD7541C7EAB25EE7AC2D51561B66F801E556C3D1B051E42F95F7BE09F3859AE21E4FFE163D82DF986628C5C65EEA52A1AE5432A31D62516C803C7711C09B2003B41B70B24491E997E42344EAE8973792DBB8E45180B5832F6E7B4541394AEAE497E52AA2FEB3CBE0E93E2DD2696006A125802BE66BFC6847A85DE678620AF0642FAD02C90977B296440BF5C15485701EB089499AF70FD77D80F2980F16B36434F78886EF71C5FE0257257794EB11EA47D23CA661F9F10B48C90CF338CF57CF81338ECF9CF1FFE0356E37D95BC3A0000, 
'6.1.3-40302');
  END IF;

END //

DELIMITER ;

CALL `_idempotent_script`();

DROP PROCEDURE IF EXISTS `_idempotent_script`;
