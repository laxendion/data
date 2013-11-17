

--
-- 转存表中的数据 `authorised_values`
--

INSERT INTO `authorised_values` (`id`, `category`, `authorised_value`, `lib`, `lib_opac`, `imageurl`) VALUES
(1, 'YES_NO', '0', 'No', 'No', NULL),
(2, 'YES_NO', '1', 'Yes', 'Yes', NULL),
(3, 'LOST', '1', '丢失', NULL, ''),
(4, 'LOST', '2', '长期未还', NULL, ''),
(5, 'LOST', '3', '丢失已赔', NULL, ''),
(6, 'LOST', '4', '找不到', NULL, ''),
(7, 'DAMAGED', '1', '损坏', NULL, ''),
(8, 'NOT_LOAN', '1', '阅览书', NULL, ''),
(9, 'NOT_LOAN', '-1', '订购中', NULL, ''),
(11, 'CCODE', 'FIC', '虚构类', NULL, ''),
(12, 'CCODE', 'NOFIC', '非虚构类', NULL, '');
