-- GameData1
-- Author: lhjg
-- DateCreated: 2/7/2023 11:42:46 PM
--------------------------------------------------------------
insert or replace into EventPopupData
(Type,					Title,							Description,							Effects,					ForegroundImage,       BackgroundImage) values
('EVENT_COMET_BAD',			'LOC_EVENT_COMET_SIGHTED_TITLE',			'LOC_EVENT_COMET_SIGHTED_DESCRIPTION',			'LOC_EVENT_COMET_BAD_EFFECT',		'CometSighted.dds',               null),
--Requires not having comet sense
('EVENT_COMET_GOOD',			'LOC_EVENT_COMET_SIGHTED_TITLE',			'LOC_EVENT_COMET_SIGHTED_DESCRIPTION',			'LOC_EVENT_COMET_GOOD_EFFECT',		'CometSighted.dds',               null),
--Requires Telescope
('EVENT_COMET_MODERN',			'LOC_EVENT_COMET_SIGHTED_TITLE',			'LOC_EVENT_COMET_SIGHTED_DESCRIPTION',			'LOC_EVENT_TEMPLATE_ONE_CHOICE_EFFECT',		'CometSighted.dds',               null),
--Requires being in Atomic times
('EVENT_COMET_BAD_MODERN',			'LOC_EVENT_COMET_SIGHTED_TITLE',			'LOC_EVENT_COMET_SIGHTED_DESCRIPTION',			'LOC_EVENT_TEMPLATE_ONE_CHOICE_EFFECT',		'CometSighted.dds',               null),
--Requires being in Atomic times
('EVENT_KOMET_PLANE',			'LOC_EVENT_KOMET_SIGHTED_TITLE',			'LOC_EVENT_COMET_SIGHTED_DESCRIPTION',			'LOC_EVENT_TEMPLATE_ONE_CHOICE_EFFECT',		'CometSighted.dds',               null);
--Requires rocketry and create a plane
