
DROP TABLE IF EXISTS bf_pays_continent CASCADE;

CREATE TABLE bf_pays_continent (
  id SERIAL PRIMARY KEY,
  code INT NOT NULL,
  code_2L VARCHAR(2) NOT NULL,
  code_3L VARCHAR(3) NOT NULL,
  nom_pays_fr VARCHAR(100) NOT NULL,
  nom_pays_en VARCHAR(100) NOT NULL,
  indicatif VARCHAR(10) NOT NULL,
  continent_fr VARCHAR(50),
  continent_en VARCHAR(50)
);


INSERT INTO bf_pays_continent (code, code_2L, code_3L, nom_pays_en, nom_pays_fr, indicatif, continent_fr, continent_en) VALUES
(4, 'AF', 'AFG', 'Afghanistan', 'Afghanistan', '+93', 'Asie', 'Asia'),
(8, 'AL', 'ALB', 'Albania', 'Albanie', '+355', 'Europe', 'Europe'),
(12, 'DZ', 'DZA', 'Algeria', 'Algérie', '+213', 'Afrique', 'Africa'),
(16, 'AS', 'ASM', 'American Samoa', 'Samoa Américaines', '+1', 'Océanie', 'Oceania'),
(20, 'AD', 'AND', 'Andorra', 'Andorre', '+376', 'Europe', 'Europe'),
(24, 'AO', 'AGO', 'Angola', 'Angola', '+244', 'Afrique', 'Africa'),
(28, 'AG', 'ATG', 'Antigua and Barbuda', 'Antigua-et-Barbuda', '+1', 'Amérique', 'North America'),
(31, 'AZ', 'AZE', 'Azerbaijan', 'Azerbaïdjan', '+994', 'Asie', 'Asia'),
(32, 'AR', 'ARG', 'Argentina', 'Argentine', '+54', 'Amérique', 'South America'),
(36, 'AU', 'AUS', 'Australia', 'Australie', '+61', 'Océanie', 'Oceania'),
(40, 'AT', 'AUT', 'Austria', 'Autriche', '+43', 'Europe', 'Europe'),
(44, 'BS', 'BHS', 'Bahamas', 'Bahamas', '+1', 'Amérique', 'North America'),
(48, 'BH', 'BHR', 'Bahrain', 'Bahreïn', '+973', 'Asie', 'Asia'),
(50, 'BD', 'BGD', 'Bangladesh', 'Bangladesh', '+880', 'Asie', 'Asia'),
(51, 'AM', 'ARM', 'Armenia', 'Arménie', '+374', 'Asie', 'Asia'),
(52, 'BB', 'BRB', 'Barbados', 'Barbade', '+1', 'Amérique', 'North America'),
(56, 'BE', 'BEL', 'Belgium', 'Belgique', '+32', 'Europe', 'Europe'),
(60, 'BM', 'BMU', 'Bermuda', 'Bermudes', '+1', 'Amérique', 'North America'),
(64, 'BT', 'BTN', 'Bhutan', 'Bhoutan', '+975', 'Asie', 'Asia'),
(68, 'BO', 'BOL', 'Bolivia', 'Bolivie', '+591', 'Amérique', 'South America'),
(70, 'BA', 'BIH', 'Bosnia and Herzegovina', 'Bosnie-Herzégovine', '+387', 'Europe', 'Europe'),
(72, 'BW', 'BWA', 'Botswana', 'Botswana', '+267', 'Afrique', 'Africa'),
(76, 'BR', 'BRA', 'Brazil', 'Brésil', '+55', 'Amérique', 'South America'),
(84, 'BZ', 'BLZ', 'Belize', 'Belize', '+501', 'Amérique', 'North America'),
(86, 'IO', 'IOT', 'British Indian Ocean Territory', 'Territoire Britannique de l''Océan Indien', '+246', 'Asie', 'Asia'),
(90, 'SB', 'SLB', 'Solomon Islands', 'Îles Salomon', '+677', 'Océanie', 'Oceania'),
(92, 'VG', 'VGB', 'British Virgin Islands', 'Îles Vierges Britanniques', '+1', 'Amérique', 'North America'),
(96, 'BN', 'BRN', 'Brunei Darussalam', 'Brunéi Darussalam', '+673', 'Asie', 'Asia'),
(100, 'BG', 'BGR', 'Bulgaria', 'Bulgarie', '+359', 'Europe', 'Europe'),
(104, 'MM', 'MMR', 'Myanmar', 'Myanmar', '+95', 'Asie', 'Asia'),
(108, 'BI', 'BDI', 'Burundi', 'Burundi', '+257', 'Afrique', 'Africa'),
(112, 'BY', 'BLR', 'Belarus', 'Bélarus', '+375', 'Europe', 'Europe'),
(116, 'KH', 'KHM', 'Cambodia', 'Cambodge', '+855', 'Asie', 'Asia'),
(120, 'CM', 'CMR', 'Cameroon', 'Cameroun', '+237', 'Afrique', 'Africa'),
(124, 'CA', 'CAN', 'Canada', 'Canada', '+1', 'Amérique', 'North America'),
(132, 'CV', 'CPV', 'Cape Verde', 'Cap-Vert', '+238', 'Afrique', 'Africa'),
(136, 'KY', 'CYM', 'Cayman Islands', 'Îles Caïmans', '+1', 'Amérique', 'North America'),
(140, 'CF', 'CAF', 'Central African Republic', 'République Centrafricaine', '+236', 'Afrique', 'Africa'),
(144, 'LK', 'LKA', 'Sri Lanka', 'Sri Lanka', '+94', 'Asie', 'Asia'),
(148, 'TD', 'TCD', 'Chad', 'Tchad', '+235', 'Afrique', 'Africa'),
(152, 'CL', 'CHL', 'Chile', 'Chili', '+56', 'Amérique', 'South America'),
(156, 'CN', 'CHN', 'China', 'Chine', '+86', 'Asie', 'Asia'),
(158, 'TW', 'TWN', 'Taiwan', 'Taïwan', '+886', 'Asie', 'Asia'),
(162, 'CX', 'CXR', 'Christmas Island', 'Île Christmas', '+61', 'Océanie', 'Oceania'),
(166, 'CC', 'CCK', 'Cocos (Keeling) Islands', 'Îles Cocos (Keeling)', '+61', 'Océanie', 'Oceania'),
(170, 'CO', 'COL', 'Colombia', 'Colombie', '+57', 'Amérique', 'South America'),
(174, 'KM', 'COM', 'Comoros', 'Comores', '+269', 'Afrique', 'Africa'),
(175, 'YT', 'MYT', 'Mayotte', 'Mayotte', '+262', 'Afrique', 'Africa'),
(178, 'CG', 'COG', 'Congo', 'Congo', '+242', 'Afrique', 'Africa'),
(180, 'CD', 'COD', 'Congo, Democratic Republic of the', 'Congo, République Démocratique du', '+243', 'Afrique', 'Africa'),
(184, 'CK', 'COK', 'Cook Islands', 'Îles Cook', '+682', 'Océanie', 'Oceania'),
(188, 'CR', 'CRI', 'Costa Rica', 'Costa Rica', '+506', 'Amérique', 'North America'),
(191, 'HR', 'HRV', 'Croatia', 'Croatie', '+385', 'Europe', 'Europe'),
(192, 'CU', 'CUB', 'Cuba', 'Cuba', '+53', 'Amérique', 'North America'),
(196, 'CY', 'CYP', 'Cyprus', 'Chypre', '+357', 'Europe', 'Europe'),
(203, 'CZ', 'CZE', 'Czech Republic', 'République Tchèque', '+420', 'Europe', 'Europe'),
(204, 'BJ', 'BEN', 'Benin', 'Bénin', '+229', 'Afrique', 'Africa'),
(208, 'DK', 'DNK', 'Denmark', 'Danemark', '+45', 'Europe', 'Europe'),
(212, 'DM', 'DMA', 'Dominica', 'Dominique', '+1', 'Amérique', 'North America'),
(214, 'DO', 'DOM', 'Dominican Republic', 'République Dominicaine', '+1', 'Amérique', 'North America'),
(218, 'EC', 'ECU', 'Ecuador', 'Équateur', '+593', 'Amérique', 'South America'),
(222, 'SV', 'SLV', 'El Salvador', 'El Salvador', '+503', 'Amérique', 'North America'),
(226, 'GQ', 'GNQ', 'Equatorial Guinea', 'Guinée Équatoriale', '+240', 'Afrique', 'Africa'),
(231, 'ET', 'ETH', 'Ethiopia', 'Éthiopie', '+251', 'Afrique', 'Africa'),
(232, 'ER', 'ERI', 'Eritrea', 'Érythrée', '+291', 'Afrique', 'Africa'),
(233, 'EE', 'EST', 'Estonia', 'Estonie', '+372', 'Europe', 'Europe'),
(234, 'FO', 'FRO', 'Faroe Islands', 'Îles Féroé', '+298', 'Europe', 'Europe'),
(238, 'FK', 'FLK', 'Falkland Islands (Malvinas)', 'Îles Malouines (Falkland)', '+500', 'Amérique', 'South America'),
(239, 'GS', 'SGS', 'South Georgia and the South Sandwich Islands', 'Géorgie du Sud et les îles Sandwich du Sud', '+500', 'Amérique', 'South America'),
(242, 'FJ', 'FJI', 'Fiji', 'Fidji', '+679', 'Océanie', 'Oceania'),
(246, 'FI', 'FIN', 'Finland', 'Finlande', '+358', 'Europe', 'Europe'),
(248, 'AX', 'ALA', 'Åland Islands', 'Îles Åland', '+358', 'Europe', 'Europe'),
(250, 'FR', 'FRA', 'France', 'France', '+33', 'Europe', 'Europe'),
(254, 'GF', 'GUF', 'French Guiana', 'Guyane Française', '+594', 'Amérique', 'South America'),
(258, 'PF', 'PYF', 'French Polynesia', 'Polynésie Française', '+689', 'Océanie', 'Oceania'),
(260, 'TF', 'ATF', 'French Southern Territories', 'Terres Australes Françaises', '+262', 'Antarctique', 'Antarctica'),
(262, 'DJ', 'DJI', 'Djibouti', 'Djibouti', '+253', 'Afrique', 'Africa'),
(266, 'GA', 'GAB', 'Gabon', 'Gabon', '+241', 'Afrique', 'Africa'),
(268, 'GE', 'GEO', 'Georgia', 'Géorgie', '+995', 'Asie', 'Asia'),
(270, 'GM', 'GMB', 'Gambia', 'Gambie', '+220', 'Afrique', 'Africa'),
(275, 'PS', 'PSE', 'Palestinian Territory, Occupied', 'Territoire Palestinien Occupé', '+970', 'Asie', 'Asia'),
(276, 'DE', 'DEU', 'Germany', 'Allemagne', '+49', 'Europe', 'Europe'),
(288, 'GH', 'GHA', 'Ghana', 'Ghana', '+233', 'Afrique', 'Africa'),
(292, 'GI', 'GIB', 'Gibraltar', 'Gibraltar', '+350', 'Europe', 'Europe'),
(296, 'KI', 'KIR', 'Kiribati', 'Kiribati', '+686', 'Océanie', 'Oceania'),
(300, 'GR', 'GRC', 'Greece', 'Grèce', '+30', 'Europe', 'Europe'),
(304, 'GL', 'GRL', 'Greenland', 'Groenland', '+299', 'Amérique', 'North America'),
(308, 'GD', 'GRD', 'Grenada', 'Grenade', '+1', 'Amérique', 'North America'),
(312, 'GP', 'GLP', 'Guadeloupe', 'Guadeloupe', '+590', 'Amérique', 'North America'),
(316, 'GU', 'GUM', 'Guam', 'Guam', '+1', 'Océanie', 'Oceania'),
(320, 'GT', 'GTM', 'Guatemala', 'Guatemala', '+502', 'Amérique', 'North America'),
(324, 'GN', 'GIN', 'Guinea', 'Guinée', '+224', 'Afrique', 'Africa'),
(328, 'GY', 'GUY', 'Guyana', 'Guyana', '+592', 'Amérique', 'South America'),
(332, 'HT', 'HTI', 'Haiti', 'Haïti', '+509', 'Amérique', 'North America'),
(334, 'HM', 'HMD', 'Heard Island and McDonald Islands', 'Îles Heard et MacDonald', '', 'Océanie', 'Oceania'),
(336, 'VA', 'VAT', 'Holy See (Vatican City State)', 'Saint-Siège (État de la Cité du Vatican)', '+379', 'Europe', 'Europe'),
(340, 'HN', 'HND', 'Honduras', 'Honduras', '+504', 'Amérique', 'North America'),
(344, 'HK', 'HKG', 'Hong Kong', 'Hong Kong', '+852', 'Asie', 'Asia'),
(348, 'HU', 'HUN', 'Hungary', 'Hongrie', '+36', 'Europe', 'Europe'),
(352, 'IS', 'ISL', 'Iceland', 'Islande', '+354', 'Europe', 'Europe'),
(356, 'IN', 'IND', 'India', 'Inde', '+91', 'Asie', 'Asia'),
(360, 'ID', 'IDN', 'Indonesia', 'Indonésie', '+62', 'Asie', 'Asia'),
(364, 'IR', 'IRN', 'Iran, Islamic Republic of', 'Iran, République Islamique d''', '+98', 'Asie', 'Asia'),
(368, 'IQ', 'IRQ', 'Iraq', 'Irak', '+964', 'Asie', 'Asia'),
(372, 'IE', 'IRL', 'Ireland', 'Irlande', '+353', 'Europe', 'Europe'),
(376, 'IL', 'ISR', 'Israel', 'Israël', '+972', 'Asie', 'Asia'),
(380, 'IT', 'ITA', 'Italy', 'Italie', '+39', 'Europe', 'Europe'),
(384, 'CI', 'CIV', 'Côte d''Ivoire', 'Côte d''Ivoire', '+225', 'Afrique', 'Africa'),
(388, 'JM', 'JAM', 'Jamaica', 'Jamaïque', '+1', 'Amérique', 'North America'),
(392, 'JP', 'JPN', 'Japan', 'Japon', '+81', 'Asie', 'Asia'),
(398, 'KZ', 'KAZ', 'Kazakhstan', 'Kazakhstan', '+7', 'Asie', 'Asia'),
(400, 'JO', 'JOR', 'Jordan', 'Jordanie', '+962', 'Asie', 'Asia'),
(404, 'KE', 'KEN', 'Kenya', 'Kenya', '+254', 'Afrique', 'Africa'),
(408, 'KP', 'PRK', 'Korea, Democratic People''s Republic of', 'Corée, République Populaire Démocratique de', '+850', 'Asie', 'Asia'),
(410, 'KR', 'KOR', 'Korea, Republic of', 'Corée, République de', '+82', 'Asie', 'Asia'),
(414, 'KW', 'KWT', 'Kuwait', 'Koweït', '+965', 'Asie', 'Asia'),
(417, 'KG', 'KGZ', 'Kyrgyzstan', 'Kirghizistan', '+996', 'Asie', 'Asia'),
(418, 'LA', 'LAO', 'Lao People''s Democratic Republic', 'Laos, République Démocratique Populaire', '+856', 'Asie', 'Asia'),
(422, 'LB', 'LBN', 'Lebanon', 'Liban', '+961', 'Asie', 'Asia'),
(426, 'LS', 'LSO', 'Lesotho', 'Lesotho', '+266', 'Afrique', 'Africa'),
(428, 'LV', 'LVA', 'Latvia', 'Lettonie', '+371', 'Europe', 'Europe'),
(430, 'LR', 'LBR', 'Liberia', 'Libéria', '+231', 'Afrique', 'Africa'),
(434, 'LY', 'LBY', 'Libyan Arab Jamahiriya', 'Libye', '+218', 'Afrique', 'Africa'),
(438, 'LI', 'LIE', 'Liechtenstein', 'Liechtenstein', '+423', 'Europe', 'Europe'),
(440, 'LT', 'LTU', 'Lithuania', 'Lituanie', '+370', 'Europe', 'Europe'),
(442, 'LU', 'LUX', 'Luxembourg', 'Luxembourg', '+352', 'Europe', 'Europe'),
(446, 'MO', 'MAC', 'Macao', 'Macao', '+853', 'Asie', 'Asia'),
(450, 'MG', 'MDG', 'Madagascar', 'Madagascar', '+261', 'Afrique', 'Africa'),
(454, 'MW', 'MWI', 'Malawi', 'Malawi', '+265', 'Afrique', 'Africa'),
(458, 'MY', 'MYS', 'Malaysia', 'Malaisie', '+60', 'Asie', 'Asia'),
(462, 'MV', 'MDV', 'Maldives', 'Maldives', '+960', 'Asie', 'Asia'),
(466, 'ML', 'MLI', 'Mali', 'Mali', '+223', 'Afrique', 'Africa'),
(470, 'MT', 'MLT', 'Malta', 'Malte', '+356', 'Europe', 'Europe'),
(474, 'MQ', 'MTQ', 'Martinique', 'Martinique', '+596', 'Amérique', 'North America'),
(478, 'MR', 'MRT', 'Mauritania', 'Mauritanie', '+222', 'Afrique', 'Africa'),
(480, 'MU', 'MUS', 'Mauritius', 'Île Maurice', '+230', 'Afrique', 'Africa'),
(484, 'MX', 'MEX', 'Mexico', 'Mexique', '+52', 'Amérique', 'North America'),
(492, 'MC', 'MCO', 'Monaco', 'Monaco', '+377', 'Europe', 'Europe'),
(496, 'MN', 'MNG', 'Mongolia', 'Mongolie', '+976', 'Asie', 'Asia'),
(498, 'MD', 'MDA', 'Moldova, Republic of', 'Moldavie, République de', '+373', 'Europe', 'Europe'),
(500, 'MS', 'MSR', 'Montserrat', 'Montserrat', '+1', 'Amérique', 'North America'),
(504, 'MA', 'MAR', 'Morocco', 'Maroc', '+212', 'Afrique', 'Africa'),
(508, 'MZ', 'MOZ', 'Mozambique', 'Mozambique', '+258', 'Afrique', 'Africa'),
(512, 'OM', 'OMN', 'Oman', 'Oman', '+968', 'Asie', 'Asia'),
(516, 'NA', 'NAM', 'Namibia', 'Namibie', '+264', 'Afrique', 'Africa'),
(520, 'NR', 'NRU', 'Nauru', 'Nauru', '+674', 'Océanie', 'Oceania'),
(524, 'NP', 'NPL', 'Nepal', 'Népal', '+977', 'Asie', 'Asia'),
(528, 'NL', 'NLD', 'Netherlands', 'Pays-Bas', '+31', 'Europe', 'Europe'),
(530, 'AN', 'ANT', 'Netherlands Antilles', 'Antilles Néerlandaises', '+599', 'Amérique', 'North America'),
(533, 'AW', 'ABW', 'Aruba', 'Aruba', '+297', 'Amérique', 'North America'),
(540, 'NC', 'NCL', 'New Caledonia', 'Nouvelle-Calédonie', '+687', 'Océanie', 'Oceania'),
(548, 'VU', 'VUT', 'Vanuatu', 'Vanuatu', '+678', 'Océanie', 'Oceania'),
(554, 'NZ', 'NZL', 'New Zealand', 'Nouvelle-Zélande', '+64', 'Océanie', 'Oceania'),
(558, 'NI', 'NIC', 'Nicaragua', 'Nicaragua', '+505', 'Amérique', 'North America'),
(562, 'NE', 'NER', 'Niger', 'Niger', '+227', 'Afrique', 'Africa'),
(566, 'NG', 'NGA', 'Nigeria', 'Nigéria', '+234', 'Afrique', 'Africa'),
(570, 'NU', 'NIU', 'Niue', 'Nioué', '+683', 'Océanie', 'Oceania'),
(574, 'NF', 'NFK', 'Norfolk Island', 'Île Norfolk', '+672', 'Océanie', 'Oceania'),
(578, 'NO', 'NOR', 'Norway', 'Norvège', '+47', 'Europe', 'Europe'),
(580, 'MP', 'MNP', 'Northern Mariana Islands', 'Îles Mariannes du Nord', '+1', 'Océanie', 'Oceania'),
(581, 'UM', 'UMI', 'United States Minor Outlying Islands', 'Îles Mineures Éloignées des États-Unis', '', 'Amérique', 'North America'),
(583, 'FM', 'FSM', 'Micronesia, Federated States of', 'Micronésie, États Fédérés de', '+691', 'Océanie', 'Oceania'),
(584, 'MH', 'MHL', 'Marshall Islands', 'Îles Marshall', '+692', 'Océanie', 'Oceania'),
(585, 'PW', 'PLW', 'Palau', 'Palaos', '+680', 'Océanie', 'Oceania'),
(586, 'PK', 'PAK', 'Pakistan', 'Pakistan', '+92', 'Asie', 'Asia'),
(591, 'PA', 'PAN', 'Panama', 'Panama', '+507', 'Amérique', 'North America'),
(598, 'PG', 'PNG', 'Papua New Guinea', 'Papouasie-Nouvelle-Guinée', '+675', 'Océanie', 'Oceania'),
(600, 'PY', 'PRY', 'Paraguay', 'Paraguay', '+595', 'Amérique', 'South America'),
(604, 'PE', 'PER', 'Peru', 'Pérou', '+51', 'Amérique', 'South America'),
(608, 'PH', 'PHL', 'Philippines', 'Philippines', '+63', 'Asie', 'Asia'),
(612, 'PN', 'PCN', 'Pitcairn', 'Îles Pitcairn', '+64', 'Océanie', 'Oceania'),
(616, 'PL', 'POL', 'Poland', 'Pologne', '+48', 'Europe', 'Europe'),
(620, 'PT', 'PRT', 'Portugal', 'Portugal', '+351', 'Europe', 'Europe'),
(624, 'GW', 'GNB', 'Guinea-Bissau', 'Guinée-Bissau', '+245', 'Afrique', 'Africa'),
(626, 'TL', 'TLS', 'Timor-Leste', 'Timor-Leste', '+670', 'Asie', 'Asia'),
(630, 'PR', 'PRI', 'Puerto Rico', 'Porto Rico', '+1', 'Amérique', 'North America'),
(634, 'QA', 'QAT', 'Qatar', 'Qatar', '+974', 'Asie', 'Asia'),
(638, 'RE', 'REU', 'Réunion', 'La Réunion', '+262', 'Afrique', 'Africa'),
(642, 'RO', 'ROU', 'Romania', 'Roumanie', '+40', 'Europe', 'Europe'),
(643, 'RU', 'RUS', 'Russian Federation', 'Fédération de Russie', '+7', 'Europe', 'Europe'),
(646, 'RW', 'RWA', 'Rwanda', 'Rwanda', '+250', 'Afrique', 'Africa'),
(654, 'SH', 'SHN', 'Saint Helena', 'Sainte-Hélène', '+290', 'Afrique', 'Africa'),
(659, 'KN', 'KNA', 'Saint Kitts and Nevis', 'Saint-Christophe-et-Niévès', '+1', 'Amérique', 'North America'),
(662, 'LC', 'LCA', 'Saint Lucia', 'Sainte-Lucie', '+1', 'Amérique', 'North America'),
(666, 'PM', 'SPM', 'Saint Pierre and Miquelon', 'Saint-Pierre-et-Miquelon', '+508', 'Amérique', 'North America'),
(670, 'VC', 'VCT', 'Saint Vincent and the Grenadines', 'Saint-Vincent-et-les Grenadines', '+1', 'Amérique', 'North America'),
(674, 'SM', 'SMR', 'San Marino', 'Saint-Marin', '+378', 'Europe', 'Europe'),
(678, 'ST', 'STP', 'Sao Tome and Principe', 'Sao Tomé-et-Principe', '+239', 'Afrique', 'Africa'),
(682, 'SA', 'SAU', 'Saudi Arabia', 'Arabie Saoudite', '+966', 'Asie', 'Asia'),
(686, 'SN', 'SEN', 'Senegal', 'Sénégal', '+221', 'Afrique', 'Africa'),
(688, 'RS', 'SRB', 'Serbia', 'Serbie', '+381', 'Europe', 'Europe'),
(690, 'SC', 'SYC', 'Seychelles', 'Seychelles', '+248', 'Afrique', 'Africa'),
(694, 'SL', 'SLE', 'Sierra Leone', 'Sierra Leone', '+232', 'Afrique', 'Africa'),
(702, 'SG', 'SGP', 'Singapore', 'Singapour', '+65', 'Asie', 'Asia'),
(703, 'SK', 'SVK', 'Slovakia', 'Slovaquie', '+421', 'Europe', 'Europe'),
(704, 'VN', 'VNM', 'Viet Nam', 'Viet Nam', '+84', 'Asie', 'Asia'),
(705, 'SI', 'SVN', 'Slovenia', 'Slovénie', '+386', 'Europe', 'Europe'),
(706, 'SO', 'SOM', 'Somalia', 'Somalie', '+252', 'Afrique', 'Africa'),
(710, 'ZA', 'ZAF', 'South Africa', 'Afrique du Sud', '+27', 'Afrique', 'Africa'),
(716, 'ZW', 'ZWE', 'Zimbabwe', 'Zimbabwe', '+263', 'Afrique', 'Africa'),
(724, 'ES', 'ESP', 'Spain', 'Espagne', '+34', 'Europe', 'Europe'),
(732, 'EH', 'ESH', 'Western Sahara', 'Sahara Occidental', '+212', 'Afrique', 'Africa'),
(736, 'SD', 'SDN', 'Sudan', 'Soudan', '+249', 'Afrique', 'Africa'),
(740, 'SR', 'SUR', 'Suriname', 'Suriname', '+597', 'Amérique', 'South America'),
(744, 'SJ', 'SJM', 'Svalbard and Jan Mayen', 'Svalbard et Île Jan Mayen', '+47', 'Europe', 'Europe'),
(748, 'SZ', 'SWZ', 'Swaziland', 'Swaziland', '+268', 'Afrique', 'Africa'),
(752, 'SE', 'SWE', 'Sweden', 'Suède', '+46', 'Europe', 'Europe'),
(756, 'CH', 'CHE', 'Switzerland', 'Suisse', '+41', 'Europe', 'Europe'),
(760, 'SY', 'SYR', 'Syrian Arab Republic', 'République Arabe Syrienne', '+963', 'Asie', 'Asia'),
(762, 'TJ', 'TJK', 'Tajikistan', 'Tadjikistan', '+992', 'Asie', 'Asia'),
(764, 'TH', 'THA', 'Thailand', 'Thaïlande', '+66', 'Asie', 'Asia'),
(768, 'TG', 'TGO', 'Togo', 'Togo', '+228', 'Afrique', 'Africa'),
(772, 'TK', 'TKL', 'Tokelau', 'Tokelau', '+690', 'Océanie', 'Oceania'),
(776, 'TO', 'TON', 'Tonga', 'Tonga', '+676', 'Océanie', 'Oceania'),
(780, 'TT', 'TTO', 'Trinidad and Tobago', 'Trinité-et-Tobago', '+1', 'Amérique', 'North America'),
(784, 'AE', 'ARE', 'United Arab Emirates', 'Émirats Arabes Unis', '+971', 'Asie', 'Asia'),
(788, 'TN', 'TUN', 'Tunisia', 'Tunisie', '+216', 'Afrique', 'Africa'),
(792, 'TR', 'TUR', 'Turkey', 'Turquie', '+90', 'Asie', 'Asia'),
(795, 'TM', 'TKM', 'Turkmenistan', 'Turkménistan', '+993', 'Asie', 'Asia'),
(796, 'TC', 'TCA', 'Turks and Caicos Islands', 'Îles Turks et Caïques', '+1', 'Amérique', 'North America'),
(798, 'TV', 'TUV', 'Tuvalu', 'Tuvalu', '+688', 'Océanie', 'Oceania'),
(800, 'UG', 'UGA', 'Uganda', 'Ouganda', '+256', 'Afrique', 'Africa'),
(804, 'UA', 'UKR', 'Ukraine', 'Ukraine', '+380', 'Europe', 'Europe'),
(807, 'MK', 'MKD', 'Macedonia, the Former Yugoslav Republic of', 'Macédoine, l''ex-République Yougoslave de', '+389', 'Europe', 'Europe'),
(818, 'EG', 'EGY', 'Egypt', 'Égypte', '+20', 'Afrique', 'Africa'),
(826, 'GB', 'GBR', 'United Kingdom', 'Royaume-Uni', '+44', 'Europe', 'Europe'),
(831, 'GG', 'GGY', 'Guernsey', 'Guernesey', '+44', 'Europe', 'Europe'),
(832, 'JE', 'JEY', 'Jersey', 'Jersey', '+44', 'Europe', 'Europe'),
(833, 'IM', 'IMN', 'Isle of Man', 'Île de Man', '+44', 'Europe', 'Europe'),
(834, 'TZ', 'TZA', 'Tanzania, United Republic of', 'Tanzanie, République-Unie de', '+255', 'Afrique', 'Africa'),
(840, 'US', 'USA', 'United States', 'États-Unis', '+1', 'Amérique', 'North America'),
(850, 'VI', 'VIR', 'Virgin Islands, U.S.', 'Îles Vierges des États-Unis', '+1', 'Amérique', 'North America'),
(854, 'BF', 'BFA', 'Burkina Faso', 'Burkina Faso', '+226', 'Afrique', 'Africa'),
(858, 'UY', 'URY', 'Uruguay', 'Uruguay', '+598', 'Amérique', 'South America'),
(860, 'UZ', 'UZB', 'Uzbekistan', 'Ouzbékistan', '+998', 'Asie', 'Asia'),
(862, 'VE', 'VEN', 'Venezuela, Bolivarian Republic of', 'Venezuela, République Bolivarienne du', '+58', 'Amérique', 'South America'),
(876, 'WF', 'WLF', 'Wallis and Futuna', 'Wallis-et-Futuna', '+681', 'Océanie', 'Oceania'),
(882, 'WS', 'WSM', 'Samoa', 'Samoa', '+685', 'Océanie', 'Oceania'),
(887, 'YE', 'YEM', 'Yemen', 'Yémen', '+967', 'Asie', 'Asia'),
(891, 'CS', 'SCG', 'Serbia and Montenegro', 'Serbie-et-Monténégro', '', 'Europe', 'Europe'),
(894, 'ZM', 'ZMB', 'Zambia', 'Zambie', '+260', 'Afrique', 'Africa'),
(716, 'ZW', 'ZWE', 'Zimbabwe', 'Zimbabwe', '+263', 'Afrique', 'Africa');



-- DROP INDEX IF EXISTS idx_nom_pays_fr;
-- DROP INDEX IF EXISTS idx_nom_pays_en;
-- DROP INDEX IF EXISTS idx_continent_fr;
-- DROP INDEX IF EXISTS idx_continent_en;
-- DROP INDEX IF EXISTS idx_nom_pays_fr;
-- DROP INDEX IF EXISTS idx_code_2l;
-- DROP INDEX IF EXISTS idx_code_3l;

CREATE INDEX idx_nom_pays_fr ON bf_pays_continent(nom_pays_fr);
CREATE INDEX idx_nom_pays_en ON bf_pays_continent(nom_pays_en);
CREATE INDEX idx_continent_fr ON bf_pays_continent(continent_fr);
CREATE INDEX idx_continent_en ON bf_pays_continent(continent_en);
CREATE INDEX idx_code_2l ON bf_pays_continent(code_2l);
CREATE INDEX idx_code_3l ON bf_pays_continent(code_3l);


------------------------ VILLES -----------------------------------------------------------


DROP TABLE IF EXISTS bf_ville CASCADE;

CREATE TABLE bf_ville (
    id SERIAL PRIMARY KEY,
    nom_ville_fr VARCHAR(255) NOT NULL,
    nom_ville_en VARCHAR(255) NOT NULL,
    nom_pays_fr VARCHAR(255) NOT NULL
);




-- Espagne
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Madrid', 'Madrid', 'Espagne'),
('Barcelone', 'Barcelona', 'Espagne'),
('Valence', 'Valencia', 'Espagne'),
('Séville', 'Seville', 'Espagne'),
('Saragosse', 'Zaragoza', 'Espagne'),
('Málaga', 'Málaga', 'Espagne'),
('Murcie', 'Murcia', 'Espagne'),
('Palma', 'Palma', 'Espagne'),
('Las Palmas', 'Las Palmas', 'Espagne'),
('Bilbao', 'Bilbao', 'Espagne');

-- Italie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Rome', 'Rome', 'Italie'),
('Milan', 'Milan', 'Italie'),
('Naples', 'Naples', 'Italie'),
('Turin', 'Turin', 'Italie'),
('Palerme', 'Palermo', 'Italie'),
('Gênes', 'Genoa', 'Italie'),
('Bologne', 'Bologna', 'Italie'),
('Florence', 'Florence', 'Italie'),
('Bari', 'Bari', 'Italie'),
('Catane', 'Catania', 'Italie');

-- Allemagne
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Berlin', 'Berlin', 'Allemagne'),
('Hambourg', 'Hamburg', 'Allemagne'),
('Munich', 'Munich', 'Allemagne'),
('Cologne', 'Cologne', 'Allemagne'),
('Francfort', 'Frankfurt', 'Allemagne'),
('Stuttgart', 'Stuttgart', 'Allemagne'),
('Düsseldorf', 'Düsseldorf', 'Allemagne'),
('Dortmund', 'Dortmund', 'Allemagne'),
('Essen', 'Essen', 'Allemagne'),
('Leipzig', 'Leipzig', 'Allemagne');

-- Royaume-Uni
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Londres', 'London', 'Royaume-Uni'),
('Birmingham', 'Birmingham', 'Royaume-Uni'),
('Manchester', 'Manchester', 'Royaume-Uni'),
('Glasgow', 'Glasgow', 'Royaume-Uni'),
('Liverpool', 'Liverpool', 'Royaume-Uni'),
('Bristol', 'Bristol', 'Royaume-Uni'),
('Sheffield', 'Sheffield', 'Royaume-Uni'),
('Leeds', 'Leeds', 'Royaume-Uni'),
('Édimbourg', 'Edinburgh', 'Royaume-Uni'),
('Leicester', 'Leicester', 'Royaume-Uni');

-- Pologne
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Varsovie', 'Warsaw', 'Pologne'),
('Cracovie', 'Krakow', 'Pologne'),
('Łódź', 'Łódź', 'Pologne'),
('Wrocław', 'Wrocław', 'Pologne'),
('Poznań', 'Poznań', 'Pologne'),
('Gdańsk', 'Gdańsk', 'Pologne'),
('Szczecin', 'Szczecin', 'Pologne'),
('Bydgoszcz', 'Bydgoszcz', 'Pologne'),
('Lublin', 'Lublin', 'Pologne'),
('Katowice', 'Katowice', 'Pologne');

-- Roumanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bucarest', 'Bucharest', 'Roumanie'),
('Cluj-Napoca', 'Cluj-Napoca', 'Roumanie'),
('Timișoara', 'Timișoara', 'Roumanie'),
('Iași', 'Iași', 'Roumanie'),
('Constanța', 'Constanța', 'Roumanie'),
('Craiova', 'Craiova', 'Roumanie'),
('Brașov', 'Brașov', 'Roumanie'),
('Galați', 'Galați', 'Roumanie'),
('Ploiești', 'Ploiești', 'Roumanie'),
('Oradea', 'Oradea', 'Roumanie');

-- Pays-Bas
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Amsterdam', 'Amsterdam', 'Pays-Bas'),
('Rotterdam', 'Rotterdam', 'Pays-Bas'),
('La Haye', 'The Hague', 'Pays-Bas'),
('Utrecht', 'Utrecht', 'Pays-Bas'),
('Eindhoven', 'Eindhoven', 'Pays-Bas'),
('Tilbourg', 'Tilburg', 'Pays-Bas'),
('Groningue', 'Groningen', 'Pays-Bas'),
('Almere', 'Almere', 'Pays-Bas'),
('Bréda', 'Breda', 'Pays-Bas'),
('Nimègue', 'Nijmegen', 'Pays-Bas');

-- Belgique
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bruxelles', 'Brussels', 'Belgique'),
('Anvers', 'Antwerp', 'Belgique'),
('Gand', 'Ghent', 'Belgique'),
('Charleroi', 'Charleroi', 'Belgique'),
('Liège', 'Liège', 'Belgique'),
('Bruges', 'Bruges', 'Belgique'),
('Namur', 'Namur', 'Belgique'),
('Louvain', 'Leuven', 'Belgique'),
('Mons', 'Mons', 'Belgique'),
('Courtrai', 'Kortrijk', 'Belgique');

-- Grèce
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Athènes', 'Athens', 'Grèce'),
('Thessalonique', 'Thessaloniki', 'Grèce'),
('Patras', 'Patras', 'Grèce'),
('Héraklion', 'Heraklion', 'Grèce'),
('Larissa', 'Larissa', 'Grèce'),
('Volos', 'Volos', 'Grèce'),
('Rhodes', 'Rhodes', 'Grèce'),
('Ioannina', 'Ioannina', 'Grèce'),
('Chania', 'Chania', 'Grèce'),
('Chalcis', 'Chalcis', 'Grèce');

-- Portugal
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lisbonne', 'Lisbon', 'Portugal'),
('Porto', 'Porto', 'Portugal'),
('Braga', 'Braga', 'Portugal'),
('Amadora', 'Amadora', 'Portugal'),
('Coimbra', 'Coimbra', 'Portugal'),
('Funchal', 'Funchal', 'Portugal'),
('Almada', 'Almada', 'Portugal'),
('Vila Nova de Gaia', 'Vila Nova de Gaia', 'Portugal'),
('Santa Maria da Feira', 'Santa Maria da Feira', 'Portugal'),
('Portimão', 'Portimão', 'Portugal');

-- Suède
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Stockholm', 'Stockholm', 'Suède'),
('Göteborg', 'Gothenburg', 'Suède'),
('Malmö', 'Malmö', 'Suède'),
('Uppsala', 'Uppsala', 'Suède'),
('Västerås', 'Västerås', 'Suède'),
('Örebro', 'Örebro', 'Suède'),
('Linköping', 'Linköping', 'Suède'),
('Helsingborg', 'Helsingborg', 'Suède'),
('Jönköping', 'Jönköping', 'Suède'),
('Norrköping', 'Norrköping', 'Suède');

-- Autriche
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Vienne', 'Vienna', 'Autriche'),
('Graz', 'Graz', 'Autriche'),
('Linz', 'Linz', 'Autriche'),
('Salzbourg', 'Salzburg', 'Autriche'),
('Innsbruck', 'Innsbruck', 'Autriche'),
('Klagenfurt', 'Klagenfurt', 'Autriche'),
('Villach', 'Villach', 'Autriche'),
('Wels', 'Wels', 'Autriche'),
('Sankt Pölten', 'Sankt Pölten', 'Autriche'),
('Dornbirn', 'Dornbirn', 'Autriche');

-- Hongrie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Budapest', 'Budapest', 'Hongrie'),
('Debrecen', 'Debrecen', 'Hongrie'),
('Szeged', 'Szeged', 'Hongrie'),
('Miskolc', 'Miskolc', 'Hongrie'),
('Pécs', 'Pécs', 'Hongrie'),
('Győr', 'Győr', 'Hongrie'),
('Nyíregyháza', 'Nyíregyháza', 'Hongrie'),
('Kecskemét', 'Kecskemét', 'Hongrie'),
('Székesfehérvár', 'Székesfehérvár', 'Hongrie'),
('Szombathely', 'Szombathely', 'Hongrie');

-- République Tchèque
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Prague', 'Prague', 'République Tchèque'),
('Brno', 'Brno', 'République Tchèque'),
('Ostrava', 'Ostrava', 'République Tchèque'),
('Plzeň', 'Plzeň', 'République Tchèque'),
('Liberec', 'Liberec', 'République Tchèque'),
('Olomouc', 'Olomouc', 'République Tchèque'),
('České Budějovice', 'České Budějovice', 'République Tchèque'),
('Hradec Králové', 'Hradec Králové', 'République Tchèque'),
('Ústí nad Labem', 'Ústí nad Labem', 'République Tchèque'),
('Pardubice', 'Pardubice', 'République Tchèque');

-- Danemark
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Copenhague', 'Copenhagen', 'Danemark'),
('Aarhus', 'Aarhus', 'Danemark'),
('Odense', 'Odense', 'Danemark'),
('Aalborg', 'Aalborg', 'Danemark'),
('Frederiksberg', 'Frederiksberg', 'Danemark'),
('Esbjerg', 'Esbjerg', 'Danemark'),
('Randers', 'Randers', 'Danemark'),
('Kolding', 'Kolding', 'Danemark'),
('Horsens', 'Horsens', 'Danemark'),
('Vejle', 'Vejle', 'Danemark');

-- Finlande
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Helsinki', 'Helsinki', 'Finlande'),
('Espoo', 'Espoo', 'Finlande'),
('Tampere', 'Tampere', 'Finlande'),
('Vantaa', 'Vantaa', 'Finlande'),
('Oulu', 'Oulu', 'Finlande'),
('Turku', 'Turku', 'Finlande'),
('Jyväskylä', 'Jyväskylä', 'Finlande'),
('Lahti', 'Lahti', 'Finlande'),
('Kuopio', 'Kuopio', 'Finlande'),
('Kouvola', 'Kouvola', 'Finlande');

-- Norvège
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Oslo', 'Oslo', 'Norvège'),
('Bergen', 'Bergen', 'Norvège'),
('Trondheim', 'Trondheim', 'Norvège'),
('Stavanger', 'Stavanger', 'Norvège'),
('Fredrikstad', 'Fredrikstad', 'Norvège'),
('Drammen', 'Drammen', 'Norvège'),
('Porsgrunn', 'Porsgrunn', 'Norvège'),
('Skien', 'Skien', 'Norvège'),
('Kristiansand', 'Kristiansand', 'Norvège'),
('Ålesund', 'Ålesund', 'Norvège');

-- Suisse
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Zurich', 'Zurich', 'Suisse'),
('Genève', 'Geneva', 'Suisse'),
('Bâle', 'Basel', 'Suisse'),
('Lausanne', 'Lausanne', 'Suisse'),
('Berne', 'Bern', 'Suisse'),
('Winterthour', 'Winterthur', 'Suisse'),
('Lucerne', 'Lucerne', 'Suisse'),
('Saint-Gall', 'St. Gallen', 'Suisse'),
('Lugano', 'Lugano', 'Suisse'),
('Bienne', 'Biel/Bienne', 'Suisse');

-- Irlande
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Dublin', 'Dublin', 'Irlande'),
('Cork', 'Cork', 'Irlande'),
('Limerick', 'Limerick', 'Irlande'),
('Galway', 'Galway', 'Irlande'),
('Waterford', 'Waterford', 'Irlande');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Drogheda', 'Drogheda', 'Irlande'),
('Swords', 'Swords', 'Irlande'),
('Dundalk', 'Dundalk', 'Irlande'),
('Bray', 'Bray', 'Irlande'),
('Navan', 'Navan', 'Irlande');

-- Croatie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Zagreb', 'Zagreb', 'Croatie'),
('Split', 'Split', 'Croatie'),
('Rijeka', 'Rijeka', 'Croatie'),
('Osijek', 'Osijek', 'Croatie'),
('Zadar', 'Zadar', 'Croatie'),
('Pula', 'Pula', 'Croatie'),
('Slavonski Brod', 'Slavonski Brod', 'Croatie'),
('Karlovac', 'Karlovac', 'Croatie'),
('Varaždin', 'Varaždin', 'Croatie'),
('Šibenik', 'Šibenik', 'Croatie');

-- Bulgarie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Sofia', 'Sofia', 'Bulgarie'),
('Plovdiv', 'Plovdiv', 'Bulgarie'),
('Varna', 'Varna', 'Bulgarie'),
('Bourgas', 'Burgas', 'Bulgarie'),
('Roussé', 'Ruse', 'Bulgarie'),
('Stara Zagora', 'Stara Zagora', 'Bulgarie'),
('Pleven', 'Pleven', 'Bulgarie'),
('Sliven', 'Sliven', 'Bulgarie'),
('Dobrich', 'Dobrich', 'Bulgarie'),
('Choumen', 'Shumen', 'Bulgarie');

-- Slovaquie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bratislava', 'Bratislava', 'Slovaquie'),
('Košice', 'Košice', 'Slovaquie'),
('Prešov', 'Prešov', 'Slovaquie'),
('Žilina', 'Žilina', 'Slovaquie'),
('Banská Bystrica', 'Banská Bystrica', 'Slovaquie'),
('Nitra', 'Nitra', 'Slovaquie'),
('Trnava', 'Trnava', 'Slovaquie'),
('Martin', 'Martin', 'Slovaquie'),
('Trenčín', 'Trenčín', 'Slovaquie'),
('Poprad', 'Poprad', 'Slovaquie');

-- Lituanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Vilnius', 'Vilnius', 'Lituanie'),
('Kaunas', 'Kaunas', 'Lituanie'),
('Klaipėda', 'Klaipėda', 'Lituanie'),
('Šiauliai', 'Šiauliai', 'Lituanie'),
('Panevėžys', 'Panevėžys', 'Lituanie'),
('Alytus', 'Alytus', 'Lituanie'),
('Marijampolė', 'Marijampolė', 'Lituanie'),
('Mažeikiai', 'Mažeikiai', 'Lituanie'),
('Jonava', 'Jonava', 'Lituanie'),
('Utena', 'Utena', 'Lituanie');

-- Lettonie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Riga', 'Riga', 'Lettonie'),
('Daugavpils', 'Daugavpils', 'Lettonie'),
('Liepāja', 'Liepāja', 'Lettonie'),
('Jelgava', 'Jelgava', 'Lettonie'),
('Jūrmala', 'Jūrmala', 'Lettonie'),
('Ventspils', 'Ventspils', 'Lettonie'),
('Rēzekne', 'Rēzekne', 'Lettonie'),
('Valmiera', 'Valmiera', 'Lettonie'),
('Jēkabpils', 'Jēkabpils', 'Lettonie'),
('Ogre', 'Ogre', 'Lettonie');

-- Estonie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tallinn', 'Tallinn', 'Estonie'),
('Tartu', 'Tartu', 'Estonie'),
('Narva', 'Narva', 'Estonie'),
('Pärnu', 'Pärnu', 'Estonie'),
('Kohtla-Järve', 'Kohtla-Järve', 'Estonie'),
('Viljandi', 'Viljandi', 'Estonie'),
('Rakvere', 'Rakvere', 'Estonie'),
('Maardu', 'Maardu', 'Estonie'),
('Kuressaare', 'Kuressaare', 'Estonie'),
('Sillamäe', 'Sillamäe', 'Estonie');

-- Slovénie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Ljubljana', 'Ljubljana', 'Slovénie'),
('Maribor', 'Maribor', 'Slovénie'),
('Celje', 'Celje', 'Slovénie'),
('Kranj', 'Kranj', 'Slovénie'),
('Velenje', 'Velenje', 'Slovénie'),
('Koper', 'Koper', 'Slovénie'),
('Novo Mesto', 'Novo Mesto', 'Slovénie'),
('Ptuj', 'Ptuj', 'Slovénie'),
('Trbovlje', 'Trbovlje', 'Slovénie'),
('Kamnik', 'Kamnik', 'Slovénie');

-- Islande
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Reykjavik', 'Reykjavik', 'Islande'),
('Kópavogur', 'Kópavogur', 'Islande'),
('Hafnarfjörður', 'Hafnarfjörður', 'Islande'),
('Akureyri', 'Akureyri', 'Islande'),
('Reykjanesbær', 'Reykjanesbær', 'Islande'),
('Garðabær', 'Garðabær', 'Islande'),
('Mosfellsbær', 'Mosfellsbær', 'Islande'),
('Árborg', 'Árborg', 'Islande'),
('Akranes', 'Akranes', 'Islande'),
('Fjarðabyggð', 'Fjarðabyggð', 'Islande');

-- Malte
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('La Valette', 'Valletta', 'Malte'),
('Birkirkara', 'Birkirkara', 'Malte'),
('Qormi', 'Qormi', 'Malte'),
('Żabbar', 'Żabbar', 'Malte'),
('San Pawl il-Baħar', 'St. Paul''s Bay', 'Malte'),
('Mosta', 'Mosta', 'Malte'),
('Sliema', 'Sliema', 'Malte'),
('Rabat', 'Rabat', 'Malte'),
('Naxxar', 'Naxxar', 'Malte'),
('Ħamrun', 'Ħamrun', 'Malte');

-- Chypre
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Nicosie', 'Nicosia', 'Chypre'),
('Limassol', 'Limassol', 'Chypre'),
('Larnaca', 'Larnaca', 'Chypre'),
('Paphos', 'Paphos', 'Chypre'),
('Famagouste', 'Famagusta', 'Chypre'),
('Kyrenia', 'Kyrenia', 'Chypre'),
('Morphou', 'Morphou', 'Chypre'),
('Ayia Napa', 'Ayia Napa', 'Chypre'),
('Paralimni', 'Paralimni', 'Chypre'),
('Polis', 'Polis', 'Chypre');

-- Andorre
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Andorre-la-Vieille', 'Andorra la Vella', 'Andorre'),
('Escaldes-Engordany', 'Escaldes-Engordany', 'Andorre'),
('Encamp', 'Encamp', 'Andorre'),
('La Massana', 'La Massana', 'Andorre'),
('Santa Coloma', 'Santa Coloma', 'Andorre'),
('Ordino', 'Ordino', 'Andorre'),
('Sant Julià de Lòria', 'Sant Julià de Lòria', 'Andorre'),
('Canillo', 'Canillo', 'Andorre'),
('Pas de la Casa', 'Pas de la Casa', 'Andorre'),
('Arinsal', 'Arinsal', 'Andorre');

-- Liechtenstein
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Vaduz', 'Vaduz', 'Liechtenstein'),
('Schaan', 'Schaan', 'Liechtenstein'),
('Triesen', 'Triesen', 'Liechtenstein'),
('Balzers', 'Balzers', 'Liechtenstein'),
('Eschen', 'Eschen', 'Liechtenstein'),
('Mauren', 'Mauren', 'Liechtenstein'),
('Triesenberg', 'Triesenberg', 'Liechtenstein'),
('Ruggell', 'Ruggell', 'Liechtenstein'),
('Gamprin', 'Gamprin', 'Liechtenstein'),
('Schellenberg', 'Schellenberg', 'Liechtenstein');

-- Saint-Marin
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Saint-Marin', 'San Marino', 'Saint-Marin'),
('Serravalle', 'Serravalle', 'Saint-Marin'),
('Borgo Maggiore', 'Borgo Maggiore', 'Saint-Marin'),
('Domagnano', 'Domagnano', 'Saint-Marin'),
('Fiorentino', 'Fiorentino', 'Saint-Marin'),
('Acquaviva', 'Acquaviva', 'Saint-Marin'),
('Faetano', 'Faetano', 'Saint-Marin'),
('Montegiardino', 'Montegiardino', 'Saint-Marin'),
('Chiesanuova', 'Chiesanuova', 'Saint-Marin'),
('Falciano', 'Falciano', 'Saint-Marin');

-- Vatican
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Cité du Vatican', 'Vatican City', 'Vatican');

-- Serbie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Belgrade', 'Belgrade', 'Serbie'),
('Novi Sad', 'Novi Sad', 'Serbie'),
('Niš', 'Niš', 'Serbie'),
('Kragujevac', 'Kragujevac', 'Serbie'),
('Subotica', 'Subotica', 'Serbie'),
('Zrenjanin', 'Zrenjanin', 'Serbie'),
('Pančevo', 'Pančevo', 'Serbie'),
('Čačak', 'Čačak', 'Serbie'),
('Smederevo', 'Smederevo', 'Serbie'),
('Valjevo', 'Valjevo', 'Serbie');

-- Monténégro
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Podgorica', 'Podgorica', 'Monténégro'),
('Nikšić', 'Nikšić', 'Monténégro'),
('Pljevlja', 'Pljevlja', 'Monténégro'),
('Bijelo Polje', 'Bijelo Polje', 'Monténégro'),
('Cetinje', 'Cetinje', 'Monténégro'),
('Bar', 'Bar', 'Monténégro'),
('Herceg Novi', 'Herceg Novi', 'Monténégro'),
('Berane', 'Berane', 'Monténégro'),
('Budva', 'Budva', 'Monténégro'),
('Ulcinj', 'Ulcinj', 'Monténégro');

-- Macédoine du Nord
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Skopje', 'Skopje', 'Macédoine du Nord'),
('Bitola', 'Bitola', 'Macédoine du Nord'),
('Kumanovo', 'Kumanovo', 'Macédoine du Nord'),
('Prilep', 'Prilep', 'Macédoine du Nord'),
('Tetovo', 'Tetovo', 'Macédoine du Nord'),
('Veles', 'Veles', 'Macédoine du Nord'),
('Chtip', 'Shtip', 'Macédoine du Nord'),
('Ohrid', 'Ohrid', 'Macédoine du Nord'),
('Gostivar', 'Gostivar', 'Macédoine du Nord'),
('Stroumitsa', 'Strumica', 'Macédoine du Nord');

-- Bosnie-Herzégovine
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Sarajevo', 'Sarajevo', 'Bosnie-Herzégovine'),
('Banja Luka', 'Banja Luka', 'Bosnie-Herzégovine'),
('Tuzla', 'Tuzla', 'Bosnie-Herzégovine');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Zenica', 'Zenica', 'Bosnie-Herzégovine'),
('Bihać', 'Bihać', 'Bosnie-Herzégovine'),
('Mostar', 'Mostar', 'Bosnie-Herzégovine'),
('Prijedor', 'Prijedor', 'Bosnie-Herzégovine'),
('Doboj', 'Doboj', 'Bosnie-Herzégovine'),
('Brčko', 'Brčko', 'Bosnie-Herzégovine'),
('Bijeljina', 'Bijeljina', 'Bosnie-Herzégovine');

-- Albanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tirana', 'Tirana', 'Albanie'),
('Durrës', 'Durrës', 'Albanie'),
('Vlorë', 'Vlorë', 'Albanie'),
('Shkodër', 'Shkodër', 'Albanie'),
('Elbasan', 'Elbasan', 'Albanie'),
('Fier', 'Fier', 'Albanie'),
('Korçë', 'Korçë', 'Albanie'),
('Berat', 'Berat', 'Albanie'),
('Lushnjë', 'Lushnjë', 'Albanie'),
('Pogradec', 'Pogradec', 'Albanie');

-- Biélorussie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Minsk', 'Minsk', 'Biélorussie'),
('Homiel', 'Gomel', 'Biélorussie'),
('Moguilev', 'Mogilev', 'Biélorussie'),
('Vitebsk', 'Vitebsk', 'Biélorussie'),
('Hrodna', 'Grodno', 'Biélorussie'),
('Brest', 'Brest', 'Biélorussie'),
('Babrouïsk', 'Babruysk', 'Biélorussie'),
('Baranovitchi', 'Baranovichi', 'Biélorussie'),
('Barysaw', 'Borisov', 'Biélorussie'),
('Pinsk', 'Pinsk', 'Biélorussie');

-- Ukraine
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kiev', 'Kyiv', 'Ukraine'),
('Kharkiv', 'Kharkiv', 'Ukraine'),
('Odessa', 'Odessa', 'Ukraine'),
('Dnipro', 'Dnipro', 'Ukraine'),
('Donetsk', 'Donetsk', 'Ukraine'),
('Zaporijia', 'Zaporizhzhia', 'Ukraine'),
('Lviv', 'Lviv', 'Ukraine'),
('Kryvyï Rih', 'Kryvyi Rih', 'Ukraine'),
('Mykolaïv', 'Mykolaiv', 'Ukraine'),
('Sébastopol', 'Sevastopol', 'Ukraine');

-- Moldavie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Chișinău', 'Chișinău', 'Moldavie'),
('Tiraspol', 'Tiraspol', 'Moldavie'),
('Bălți', 'Bălți', 'Moldavie'),
('Bender', 'Bender', 'Moldavie'),
('Ungheni', 'Ungheni', 'Moldavie'),
('Soroca', 'Soroca', 'Moldavie'),
('Orhei', 'Orhei', 'Moldavie'),
('Cahul', 'Cahul', 'Moldavie'),
('Ceadîr-Lunga', 'Ceadîr-Lunga', 'Moldavie'),
('Edineț', 'Edineț', 'Moldavie');

-- Russie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Moscou', 'Moscow', 'Russie'),
('Saint-Pétersbourg', 'Saint Petersburg', 'Russie'),
('Novossibirsk', 'Novosibirsk', 'Russie'),
('Ekaterinbourg', 'Yekaterinburg', 'Russie'),
('Nijni Novgorod', 'Nizhny Novgorod', 'Russie'),
('Kazan', 'Kazan', 'Russie'),
('Tchéliabinsk', 'Chelyabinsk', 'Russie'),
('Omsk', 'Omsk', 'Russie'),
('Samara', 'Samara', 'Russie'),
('Rostov-sur-le-Don', 'Rostov-on-Don', 'Russie');

-- Kazakhstan
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Noursoultan', 'Nur-Sultan', 'Kazakhstan'),
('Almaty', 'Almaty', 'Kazakhstan'),
('Chimkent', 'Shymkent', 'Kazakhstan'),
('Karaganda', 'Karaganda', 'Kazakhstan'),
('Aktioubé', 'Aktobe', 'Kazakhstan'),
('Taraz', 'Taraz', 'Kazakhstan'),
('Pavlodar', 'Pavlodar', 'Kazakhstan'),
('Oust-Kamenogorsk', 'Oskemen', 'Kazakhstan'),
('Semeï', 'Semey', 'Kazakhstan'),
('Atyrau', 'Atyrau', 'Kazakhstan');

-- Géorgie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tbilissi', 'Tbilisi', 'Géorgie'),
('Koutaïssi', 'Kutaisi', 'Géorgie'),
('Batoumi', 'Batumi', 'Géorgie'),
('Roustavi', 'Rustavi', 'Géorgie'),
('Soukhoumi', 'Sukhumi', 'Géorgie'),
('Gori', 'Gori', 'Géorgie'),
('Poti', 'Poti', 'Géorgie'),
('Zougdidi', 'Zugdidi', 'Géorgie'),
('Tchiatoura', 'Chiatura', 'Géorgie'),
('Telavi', 'Telavi', 'Géorgie');

-- Arménie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Erevan', 'Yerevan', 'Arménie'),
('Gyumri', 'Gyumri', 'Arménie'),
('Vanadzor', 'Vanadzor', 'Arménie'),
('Etchmiadzine', 'Vagharshapat', 'Arménie'),
('Hrazdan', 'Hrazdan', 'Arménie'),
('Abovyan', 'Abovyan', 'Arménie'),
('Kapan', 'Kapan', 'Arménie'),
('Sevan', 'Sevan', 'Arménie'),
('Charentsavan', 'Charentsavan', 'Arménie'),
('Armavir', 'Armavir', 'Arménie');

-- Azerbaïdjan
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bakou', 'Baku', 'Azerbaïdjan'),
('Gandja', 'Ganja', 'Azerbaïdjan'),
('Soumgaït', 'Sumgayit', 'Azerbaïdjan'),
('Lankaran', 'Lankaran', 'Azerbaïdjan'),
('Chirvan', 'Shirvan', 'Azerbaïdjan'),
('Mingachevir', 'Mingachevir', 'Azerbaïdjan'),
('Nakhitchevan', 'Nakhchivan', 'Azerbaïdjan'),
('Chaki', 'Shaki', 'Azerbaïdjan'),
('Ievlakh', 'Yevlakh', 'Azerbaïdjan'),
('Quba', 'Quba', 'Azerbaïdjan');

-- Algérie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Alger', 'Algiers', 'Algérie'),
('Oran', 'Oran', 'Algérie'),
('Constantine', 'Constantine', 'Algérie'),
('Annaba', 'Annaba', 'Algérie'),
('Blida', 'Blida', 'Algérie'),
('Batna', 'Batna', 'Algérie'),
('Djelfa', 'Djelfa', 'Algérie'),
('Sétif', 'Sétif', 'Algérie'),
('Sidi Bel Abbès', 'Sidi Bel Abbès', 'Algérie'),
('Biskra', 'Biskra', 'Algérie');

-- Angola
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Luanda', 'Luanda', 'Angola'),
('Huambo', 'Huambo', 'Angola'),
('Lobito', 'Lobito', 'Angola'),
('Benguela', 'Benguela', 'Angola'),
('Kuito', 'Kuito', 'Angola'),
('Lubango', 'Lubango', 'Angola'),
('Malanje', 'Malanje', 'Angola'),
('Namibe', 'Namibe', 'Angola'),
('Soyo', 'Soyo', 'Angola'),
('Cabinda', 'Cabinda', 'Angola');

-- Bénin
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Cotonou', 'Cotonou', 'Bénin'),
('Abomey-Calavi', 'Abomey-Calavi', 'Bénin'),
('Djougou', 'Djougou', 'Bénin'),
('Porto-Novo', 'Porto-Novo', 'Bénin'),
('Parakou', 'Parakou', 'Bénin'),
('Bohicon', 'Bohicon', 'Bénin'),
('Kandi', 'Kandi', 'Bénin'),
('Lokossa', 'Lokossa', 'Bénin'),
('Ouidah', 'Ouidah', 'Bénin'),
('Natitingou', 'Natitingou', 'Bénin');

-- Botswana
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Gaborone', 'Gaborone', 'Botswana'),
('Francistown', 'Francistown', 'Botswana'),
('Maun', 'Maun', 'Botswana'),
('Serowe', 'Serowe', 'Botswana'),
('Molepolole', 'Molepolole', 'Botswana'),
('Kanye', 'Kanye', 'Botswana'),
('Mochudi', 'Mochudi', 'Botswana'),
('Mahalapye', 'Mahalapye', 'Botswana'),
('Mogoditshane', 'Mogoditshane', 'Botswana'),
('Palapye', 'Palapye', 'Botswana');

-- Burkina Faso
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Ouagadougou', 'Ouagadougou', 'Burkina Faso'),
('Bobo-Dioulasso', 'Bobo-Dioulasso', 'Burkina Faso'),
('Koudougou', 'Koudougou', 'Burkina Faso'),
('Ouahigouya', 'Ouahigouya', 'Burkina Faso'),
('Banfora', 'Banfora', 'Burkina Faso'),
('Dédougou', 'Dédougou', 'Burkina Faso'),
('Kaya', 'Kaya', 'Burkina Faso'),
('Tenkodogo', 'Tenkodogo', 'Burkina Faso'),
('Fada N''Gourma', 'Fada N''Gourma', 'Burkina Faso'),
('Dori', 'Dori', 'Burkina Faso');

-- Burundi
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bujumbura', 'Bujumbura', 'Burundi'),
('Gitega', 'Gitega', 'Burundi'),
('Muyinga', 'Muyinga', 'Burundi'),
('Ngozi', 'Ngozi', 'Burundi'),
('Ruyigi', 'Ruyigi', 'Burundi'),
('Kayanza', 'Kayanza', 'Burundi'),
('Bururi', 'Bururi', 'Burundi'),
('Rutana', 'Rutana', 'Burundi'),
('Makamba', 'Makamba', 'Burundi'),
('Muramvya', 'Muramvya', 'Burundi');

-- Cameroun
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Douala', 'Douala', 'Cameroun'),
('Yaoundé', 'Yaoundé', 'Cameroun'),
('Garoua', 'Garoua', 'Cameroun'),
('Bamenda', 'Bamenda', 'Cameroun'),
('Maroua', 'Maroua', 'Cameroun'),
('Nkongsamba', 'Nkongsamba', 'Cameroun'),
('Bafoussam', 'Bafoussam', 'Cameroun'),
('Ngaoundéré', 'Ngaoundéré', 'Cameroun'),
('Bertoua', 'Bertoua', 'Cameroun'),
('Loum', 'Loum', 'Cameroun');

-- Cap-Vert
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Praia', 'Praia', 'Cap-Vert'),
('Mindelo', 'Mindelo', 'Cap-Vert'),
('Santa Maria', 'Santa Maria', 'Cap-Vert');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('São Filipe', 'São Filipe', 'Cap-Vert'),
('Pedra Badejo', 'Pedra Badejo', 'Cap-Vert'),
('Porto Novo', 'Porto Novo', 'Cap-Vert'),
('Ribeira Brava', 'Ribeira Brava', 'Cap-Vert'),
('Tarrafal', 'Tarrafal', 'Cap-Vert'),
('Sal Rei', 'Sal Rei', 'Cap-Vert');

-- République centrafricaine
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bangui', 'Bangui', 'République centrafricaine'),
('Bimbo', 'Bimbo', 'République centrafricaine'),
('Mbaïki', 'Mbaïki', 'République centrafricaine'),
('Berbérati', 'Berbérati', 'République centrafricaine'),
('Carnot', 'Carnot', 'République centrafricaine'),
('Bambari', 'Bambari', 'République centrafricaine'),
('Bouar', 'Bouar', 'République centrafricaine'),
('Bossangoa', 'Bossangoa', 'République centrafricaine'),
('Bria', 'Bria', 'République centrafricaine'),
('Kaga-Bandoro', 'Kaga-Bandoro', 'République centrafricaine');

-- Tchad
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('N''Djaména', 'N''Djamena', 'Tchad'),
('Moundou', 'Moundou', 'Tchad'),
('Sarh', 'Sarh', 'Tchad'),
('Abéché', 'Abéché', 'Tchad'),
('Kelo', 'Kelo', 'Tchad'),
('Koumra', 'Koumra', 'Tchad'),
('Pala', 'Pala', 'Tchad'),
('Am Timan', 'Am Timan', 'Tchad'),
('Bongor', 'Bongor', 'Tchad'),
('Mongo', 'Mongo', 'Tchad');

-- Comores
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Moroni', 'Moroni', 'Comores'),
('Mutsamudu', 'Mutsamudu', 'Comores'),
('Fomboni', 'Fomboni', 'Comores'),
('Domoni', 'Domoni', 'Comores'),
('Tsimbeo', 'Tsimbeo', 'Comores'),
('Ouani', 'Ouani', 'Comores'),
('Mitsoudjé', 'Mitsoudjé', 'Comores'),
('Mohéli', 'Mohéli', 'Comores'),
('Sima', 'Sima', 'Comores'),
('Koni-Djodjo', 'Koni-Djodjo', 'Comores');

-- République du Congo
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Brazzaville', 'Brazzaville', 'République du Congo'),
('Pointe-Noire', 'Pointe-Noire', 'République du Congo'),
('Dolisie', 'Dolisie', 'République du Congo'),
('Nkayi', 'Nkayi', 'République du Congo'),
('Impfondo', 'Impfondo', 'République du Congo'),
('Ouesso', 'Ouesso', 'République du Congo'),
('Madingou', 'Madingou', 'République du Congo'),
('Sibiti', 'Sibiti', 'République du Congo'),
('Owando', 'Owando', 'République du Congo'),
('Mossendjo', 'Mossendjo', 'République du Congo');

-- République démocratique du Congo
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kinshasa', 'Kinshasa', 'République démocratique du Congo'),
('Lubumbashi', 'Lubumbashi', 'République démocratique du Congo'),
('Mbuji-Mayi', 'Mbuji-Mayi', 'République démocratique du Congo'),
('Kananga', 'Kananga', 'République démocratique du Congo'),
('Kisangani', 'Kisangani', 'République démocratique du Congo'),
('Bukavu', 'Bukavu', 'République démocratique du Congo'),
('Goma', 'Goma', 'République démocratique du Congo'),
('Kolwezi', 'Kolwezi', 'République démocratique du Congo'),
('Likasi', 'Likasi', 'République démocratique du Congo'),
('Tshikapa', 'Tshikapa', 'République démocratique du Congo');

-- Côte d'Ivoire
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Abidjan', 'Abidjan', 'Côte d''Ivoire'),
('Bouaké', 'Bouaké', 'Côte d''Ivoire'),
('Daloa', 'Daloa', 'Côte d''Ivoire'),
('Korhogo', 'Korhogo', 'Côte d''Ivoire'),
('San-Pédro', 'San-Pédro', 'Côte d''Ivoire'),
('Yamoussoukro', 'Yamoussoukro', 'Côte d''Ivoire'),
('Gagnoa', 'Gagnoa', 'Côte d''Ivoire'),
('Man', 'Man', 'Côte d''Ivoire'),
('Divo', 'Divo', 'Côte d''Ivoire'),
('Abengourou', 'Abengourou', 'Côte d''Ivoire');

-- Djibouti
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Djibouti', 'Djibouti', 'Djibouti'),
('Ali Sabieh', 'Ali Sabieh', 'Djibouti'),
('Tadjourah', 'Tadjourah', 'Djibouti'),
('Obock', 'Obock', 'Djibouti'),
('Dikhil', 'Dikhil', 'Djibouti'),
('Arta', 'Arta', 'Djibouti'),
('Holhol', 'Holhol', 'Djibouti'),
('Dorra', 'Dorra', 'Djibouti'),
('Yoboki', 'Yoboki', 'Djibouti'),
('As Eyla', 'As Eyla', 'Djibouti');

-- Égypte
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Le Caire', 'Cairo', 'Égypte'),
('Alexandrie', 'Alexandria', 'Égypte'),
('Gizeh', 'Giza', 'Égypte'),
('Shubra El-Kheima', 'Shubra El-Kheima', 'Égypte'),
('Port-Saïd', 'Port Said', 'Égypte'),
('Suez', 'Suez', 'Égypte'),
('Louxor', 'Luxor', 'Égypte'),
('Mansourah', 'Mansoura', 'Égypte'),
('Tanta', 'Tanta', 'Égypte'),
('Assouan', 'Aswan', 'Égypte');

-- Guinée équatoriale
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Malabo', 'Malabo', 'Guinée équatoriale'),
('Bata', 'Bata', 'Guinée équatoriale'),
('Ebebiyin', 'Ebebiyin', 'Guinée équatoriale'),
('Mongomo', 'Mongomo', 'Guinée équatoriale'),
('Evinayong', 'Evinayong', 'Guinée équatoriale'),
('Luba', 'Luba', 'Guinée équatoriale'),
('Mbini', 'Mbini', 'Guinée équatoriale'),
('Mikomeseng', 'Mikomeseng', 'Guinée équatoriale'),
('Añisok', 'Añisok', 'Guinée équatoriale'),
('Nkimi', 'Nkimi', 'Guinée équatoriale');

-- Érythrée
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Asmara', 'Asmara', 'Érythrée'),
('Keren', 'Keren', 'Érythrée'),
('Massaoua', 'Massawa', 'Érythrée'),
('Assab', 'Assab', 'Érythrée'),
('Mendefera', 'Mendefera', 'Érythrée'),
('Dekemhare', 'Dekemhare', 'Érythrée'),
('Adi Keyh', 'Adi Keyh', 'Érythrée'),
('Barentu', 'Barentu', 'Érythrée'),
('Adi Quala', 'Adi Quala', 'Érythrée'),
('Tsorona', 'Tsorona', 'Érythrée');

-- Eswatini (Swaziland)
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mbabane', 'Mbabane', 'Eswatini'),
('Manzini', 'Manzini', 'Eswatini'),
('Big Bend', 'Big Bend', 'Eswatini'),
('Malkerns', 'Malkerns', 'Eswatini'),
('Nhlangano', 'Nhlangano', 'Eswatini'),
('Piggs Peak', 'Piggs Peak', 'Eswatini'),
('Siteki', 'Siteki', 'Eswatini'),
('Hlatikulu', 'Hlatikulu', 'Eswatini'),
('Simunye', 'Simunye', 'Eswatini'),
('Mpaka', 'Mpaka', 'Eswatini');

-- Éthiopie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Addis-Abeba', 'Addis Ababa', 'Éthiopie'),
('Dire Dawa', 'Dire Dawa', 'Éthiopie'),
('Mekele', 'Mekelle', 'Éthiopie'),
('Gondar', 'Gondar', 'Éthiopie'),
('Awasa', 'Awasa', 'Éthiopie'),
('Bahir Dar', 'Bahir Dar', 'Éthiopie'),
('Jimma', 'Jimma', 'Éthiopie'),
('Dessie', 'Dessie', 'Éthiopie'),
('Jijiga', 'Jijiga', 'Éthiopie'),
('Shashamane', 'Shashamane', 'Éthiopie');

-- Gabon
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Libreville', 'Libreville', 'Gabon'),
('Port-Gentil', 'Port-Gentil', 'Gabon'),
('Franceville', 'Franceville', 'Gabon'),
('Oyem', 'Oyem', 'Gabon'),
('Moanda', 'Moanda', 'Gabon'),
('Mouila', 'Mouila', 'Gabon'),
('Lambaréné', 'Lambaréné', 'Gabon'),
('Tchibanga', 'Tchibanga', 'Gabon'),
('Koulamoutou', 'Koulamoutou', 'Gabon'),
('Makokou', 'Makokou', 'Gabon');

-- Gambie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Banjul', 'Banjul', 'Gambie'),
('Serekunda', 'Serekunda', 'Gambie'),
('Brikama', 'Brikama', 'Gambie'),
('Bakau', 'Bakau', 'Gambie'),
('Farafenni', 'Farafenni', 'Gambie'),
('Basse Santa Su', 'Basse Santa Su', 'Gambie'),
('Bansang', 'Bansang', 'Gambie'),
('Soma', 'Soma', 'Gambie'),
('Barra', 'Barra', 'Gambie'),
('Sukuta', 'Sukuta', 'Gambie');

-- Ghana
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Accra', 'Accra', 'Ghana'),
('Kumasi', 'Kumasi', 'Ghana'),
('Tamale', 'Tamale', 'Ghana'),
('Obuasi', 'Obuasi', 'Ghana'),
('Tema', 'Tema', 'Ghana'),
('Sekondi-Takoradi', 'Sekondi-Takoradi', 'Ghana'),
('Cape Coast', 'Cape Coast', 'Ghana'),
('Teshie', 'Teshie', 'Ghana'),
('Madina', 'Madina', 'Ghana'),
('Koforidua', 'Koforidua', 'Ghana');

-- Guinée
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Conakry', 'Conakry', 'Guinée'),
('Nzérékoré', 'Nzérékoré', 'Guinée'),
('Kankan', 'Kankan', 'Guinée'),
('Kindia', 'Kindia', 'Guinée'),
('Labé', 'Labé', 'Guinée'),
('Guéckédou', 'Guéckédou', 'Guinée'),
('Mamou', 'Mamou', 'Guinée'),
('Dabola', 'Dabola', 'Guinée'),
('Kamsar', 'Kamsar', 'Guinée'),
('Kissidougou', 'Kissidougou', 'Guinée');

-- Guinée-Bissau


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bissau', 'Bissau', 'Guinée-Bissau'),
('Gabú', 'Gabú', 'Guinée-Bissau'),
('Bafatá', 'Bafatá', 'Guinée-Bissau'),
('Canchungo', 'Canchungo', 'Guinée-Bissau'),
('Bissorã', 'Bissorã', 'Guinée-Bissau'),
('Bolama', 'Bolama', 'Guinée-Bissau'),
('Catió', 'Catió', 'Guinée-Bissau'),
('Farim', 'Farim', 'Guinée-Bissau'),
('Bubaque', 'Bubaque', 'Guinée-Bissau'),
('Buba', 'Buba', 'Guinée-Bissau');

-- Kenya
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Nairobi', 'Nairobi', 'Kenya'),
('Mombasa', 'Mombasa', 'Kenya'),
('Kisumu', 'Kisumu', 'Kenya'),
('Nakuru', 'Nakuru', 'Kenya'),
('Eldoret', 'Eldoret', 'Kenya'),
('Thika', 'Thika', 'Kenya'),
('Malindi', 'Malindi', 'Kenya'),
('Kitale', 'Kitale', 'Kenya'),
('Kakamega', 'Kakamega', 'Kenya'),
('Nyeri', 'Nyeri', 'Kenya');

-- Liberia
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Monrovia', 'Monrovia', 'Liberia'),
('Gbarnga', 'Gbarnga', 'Liberia'),
('Kakata', 'Kakata', 'Liberia'),
('Bensonville', 'Bensonville', 'Liberia'),
('Harper', 'Harper', 'Liberia'),
('Voinjama', 'Voinjama', 'Liberia'),
('Buchanan', 'Buchanan', 'Liberia'),
('Zwedru', 'Zwedru', 'Liberia'),
('Robertsport', 'Robertsport', 'Liberia'),
('Greenville', 'Greenville', 'Liberia');

-- Libye
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tripoli', 'Tripoli', 'Libye'),
('Benghazi', 'Benghazi', 'Libye'),
('Misrata', 'Misrata', 'Libye'),
('Bayda', 'Bayda', 'Libye'),
('Zawiya', 'Zawiya', 'Libye'),
('Ajdabiya', 'Ajdabiya', 'Libye'),
('Tobrouk', 'Tobruk', 'Libye'),
('Zintan', 'Zintan', 'Libye'),
('Sirte', 'Sirte', 'Libye'),
('Gharyan', 'Gharyan', 'Libye');

-- Madagascar
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Antananarivo', 'Antananarivo', 'Madagascar'),
('Toamasina', 'Toamasina', 'Madagascar'),
('Antsirabe', 'Antsirabe', 'Madagascar'),
('Mahajanga', 'Mahajanga', 'Madagascar'),
('Fianarantsoa', 'Fianarantsoa', 'Madagascar'),
('Toliara', 'Toliara', 'Madagascar'),
('Antsiranana', 'Antsiranana', 'Madagascar'),
('Ambalavao', 'Ambalavao', 'Madagascar'),
('Tolagnaro', 'Tolagnaro', 'Madagascar'),
('Sambava', 'Sambava', 'Madagascar');

-- Malawi
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lilongwe', 'Lilongwe', 'Malawi'),
('Blantyre', 'Blantyre', 'Malawi'),
('Mzuzu', 'Mzuzu', 'Malawi'),
('Zomba', 'Zomba', 'Malawi'),
('Kasungu', 'Kasungu', 'Malawi'),
('Mangochi', 'Mangochi', 'Malawi'),
('Karonga', 'Karonga', 'Malawi'),
('Salima', 'Salima', 'Malawi'),
('Nkhotakota', 'Nkhotakota', 'Malawi'),
('Liwonde', 'Liwonde', 'Malawi');

-- Mali
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bamako', 'Bamako', 'Mali'),
('Sikasso', 'Sikasso', 'Mali'),
('Mopti', 'Mopti', 'Mali'),
('Koutiala', 'Koutiala', 'Mali'),
('Ségou', 'Ségou', 'Mali'),
('Kayes', 'Kayes', 'Mali'),
('Kati', 'Kati', 'Mali'),
('Gao', 'Gao', 'Mali'),
('San', 'San', 'Mali'),
('Kita', 'Kita', 'Mali');

-- Mauritanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Nouakchott', 'Nouakchott', 'Mauritanie'),
('Nouadhibou', 'Nouadhibou', 'Mauritanie'),
('Rosso', 'Rosso', 'Mauritanie'),
('Kaédi', 'Kaédi', 'Mauritanie'),
('Zouerate', 'Zouerate', 'Mauritanie'),
('Atar', 'Atar', 'Mauritanie'),
('Néma', 'Néma', 'Mauritanie'),
('Boutilimit', 'Boutilimit', 'Mauritanie'),
('Aleg', 'Aleg', 'Mauritanie'),
('Sélibabi', 'Sélibabi', 'Mauritanie');

-- Île Maurice
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Port-Louis', 'Port Louis', 'Île Maurice'),
('Beau Bassin-Rose Hill', 'Beau Bassin-Rose Hill', 'Île Maurice'),
('Vacoas-Phoenix', 'Vacoas-Phoenix', 'Île Maurice'),
('Curepipe', 'Curepipe', 'Île Maurice'),
('Quatre Bornes', 'Quatre Bornes', 'Île Maurice'),
('Triolet', 'Triolet', 'Île Maurice'),
('Goodlands', 'Goodlands', 'Île Maurice'),
('Mahébourg', 'Mahébourg', 'Île Maurice'),
('Flacq', 'Flacq', 'Île Maurice'),
('Rivière du Rempart', 'Rivière du Rempart', 'Île Maurice');

-- Mayotte
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mamoudzou', 'Mamoudzou', 'Mayotte'),
('Koungou', 'Koungou', 'Mayotte'),
('Dzaoudzi', 'Dzaoudzi', 'Mayotte'),
('Dembeni', 'Dembeni', 'Mayotte'),
('Sada', 'Sada', 'Mayotte'),
('Bandrélé', 'Bandrélé', 'Mayotte'),
('Pamandzi', 'Pamandzi', 'Mayotte'),
('Bouéni', 'Bouéni', 'Mayotte'),
('Chiconi', 'Chiconi', 'Mayotte'),
('Ouangani', 'Ouangani', 'Mayotte');

-- Maroc
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Casablanca', 'Casablanca', 'Maroc'),
('Rabat', 'Rabat', 'Maroc'),
('Fès', 'Fez', 'Maroc'),
('Marrakech', 'Marrakesh', 'Maroc'),
('Tanger', 'Tangier', 'Maroc'),
('Meknès', 'Meknes', 'Maroc'),
('Agadir', 'Agadir', 'Maroc'),
('Oujda', 'Oujda', 'Maroc'),
('Kénitra', 'Kenitra', 'Maroc'),
('Tétouan', 'Tetouan', 'Maroc');

-- Mozambique
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Maputo', 'Maputo', 'Mozambique'),
('Matola', 'Matola', 'Mozambique'),
('Beira', 'Beira', 'Mozambique'),
('Nampula', 'Nampula', 'Mozambique'),
('Chimoio', 'Chimoio', 'Mozambique'),
('Nacala', 'Nacala', 'Mozambique'),
('Quelimane', 'Quelimane', 'Mozambique'),
('Tete', 'Tete', 'Mozambique'),
('Xai-Xai', 'Xai-Xai', 'Mozambique'),
('Gurue', 'Gurue', 'Mozambique');

-- Namibie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Windhoek', 'Windhoek', 'Namibie'),
('Rundu', 'Rundu', 'Namibie'),
('Walvis Bay', 'Walvis Bay', 'Namibie'),
('Oshakati', 'Oshakati', 'Namibie'),
('Swakopmund', 'Swakopmund', 'Namibie'),
('Katima Mulilo', 'Katima Mulilo', 'Namibie'),
('Grootfontein', 'Grootfontein', 'Namibie'),
('Rehoboth', 'Rehoboth', 'Namibie'),
('Otjiwarongo', 'Otjiwarongo', 'Namibie'),
('Okahandja', 'Okahandja', 'Namibie');

-- Niger
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Niamey', 'Niamey', 'Niger'),
('Zinder', 'Zinder', 'Niger'),
('Maradi', 'Maradi', 'Niger'),
('Agadez', 'Agadez', 'Niger'),
('Tahoua', 'Tahoua', 'Niger'),
('Arlit', 'Arlit', 'Niger'),
('Dosso', 'Dosso', 'Niger'),
('Tillabéri', 'Tillabéri', 'Niger'),
('Diffa', 'Diffa', 'Niger'),
('Gaya', 'Gaya', 'Niger');

-- Nigeria
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lagos', 'Lagos', 'Nigeria'),
('Kano', 'Kano', 'Nigeria'),
('Ibadan', 'Ibadan', 'Nigeria'),
('Abuja', 'Abuja', 'Nigeria'),
('Port Harcourt', 'Port Harcourt', 'Nigeria'),
('Benin City', 'Benin City', 'Nigeria'),
('Maiduguri', 'Maiduguri', 'Nigeria'),
('Zaria', 'Zaria', 'Nigeria'),
('Aba', 'Aba', 'Nigeria'),
('Jos', 'Jos', 'Nigeria');

-- Ouganda
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kampala', 'Kampala', 'Ouganda'),
('Gulu', 'Gulu', 'Ouganda'),
('Lira', 'Lira', 'Ouganda'),
('Mbarara', 'Mbarara', 'Ouganda'),
('Jinja', 'Jinja', 'Ouganda'),
('Bwizibwera', 'Bwizibwera', 'Ouganda'),
('Mbale', 'Mbale', 'Ouganda'),
('Mukono', 'Mukono', 'Ouganda'),
('Kasese', 'Kasese', 'Ouganda'),
('Masaka', 'Masaka', 'Ouganda');

-- Rwanda
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kigali', 'Kigali', 'Rwanda'),
('Butare', 'Butare', 'Rwanda'),
('Gitarama', 'Gitarama', 'Rwanda'),
('Musanze', 'Musanze', 'Rwanda'),
('Gisenyi', 'Gisenyi', 'Rwanda'),
('Byumba', 'Byumba', 'Rwanda'),
('Cyangugu', 'Cyangugu', 'Rwanda'),
('Kibungo', 'Kibungo', 'Rwanda'),
('Kibuye', 'Kibuye', 'Rwanda'),
('Ruhengeri', 'Ruhengeri', 'Rwanda');

-- Sao Tomé-et-Principe
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('São Tomé', 'São Tomé', 'Sao Tomé-et-Principe'),
('Santo António', 'Santo António', 'Sao Tomé-et-Principe'),
('Neves', 'Neves', 'Sao Tomé-et-Principe'),
('Santana', 'Santana', 'Sao Tomé-et-Principe'),
('Trindade', 'Trindade', 'Sao Tomé-et-Principe'),
('Guadalupe', 'Guadalupe', 'Sao Tomé-et-Principe'),
('Madalena', 'Madalena', 'Sao Tomé-et-Principe'),
('Bombom', 'Bombom', 'Sao Tomé-et-Principe'),
('Santa Cruz', 'Santa Cruz', 'Sao Tomé-et-Principe'),
('Ribeira Afonso', 'Ribeira Afonso', 'Sao Tomé-et-Principe');

-- Sénégal
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Dakar', 'Dakar', 'Sénégal');
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Thiès', 'Thiès', 'Sénégal'),
('Rufisque', 'Rufisque', 'Sénégal'),
('Kaolack', 'Kaolack', 'Sénégal'),
('Ziguinchor', 'Ziguinchor', 'Sénégal'),
('Saint-Louis', 'Saint-Louis', 'Sénégal'),
('Mbour', 'Mbour', 'Sénégal'),
('Diourbel', 'Diourbel', 'Sénégal'),
('Louga', 'Louga', 'Sénégal'),
('Tambacounda', 'Tambacounda', 'Sénégal');

-- Seychelles
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Victoria', 'Victoria', 'Seychelles'),
('Anse Boileau', 'Anse Boileau', 'Seychelles'),
('Bel Ombre', 'Bel Ombre', 'Seychelles'),
('Beau Vallon', 'Beau Vallon', 'Seychelles'),
('Cascade', 'Cascade', 'Seychelles'),
('Grand Anse', 'Grand Anse', 'Seychelles'),
('Baie Lazare', 'Baie Lazare', 'Seychelles'),
('La Digue', 'La Digue', 'Seychelles'),
('Anse Royale', 'Anse Royale', 'Seychelles'),
('Takamaka', 'Takamaka', 'Seychelles');

-- Sierra Leone
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Freetown', 'Freetown', 'Sierra Leone'),
('Bo', 'Bo', 'Sierra Leone'),
('Kenema', 'Kenema', 'Sierra Leone'),
('Makeni', 'Makeni', 'Sierra Leone'),
('Koidu', 'Koidu', 'Sierra Leone'),
('Waterloo', 'Waterloo', 'Sierra Leone'),
('Port Loko', 'Port Loko', 'Sierra Leone'),
('Lunsar', 'Lunsar', 'Sierra Leone'),
('Kailahun', 'Kailahun', 'Sierra Leone'),
('Bonthe', 'Bonthe', 'Sierra Leone');

-- Somalie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mogadiscio', 'Mogadishu', 'Somalie'),
('Hargeisa', 'Hargeisa', 'Somalie'),
('Bosaso', 'Bosaso', 'Somalie'),
('Kismayo', 'Kismayo', 'Somalie'),
('Berbera', 'Berbera', 'Somalie'),
('Marka', 'Marka', 'Somalie'),
('Burao', 'Burao', 'Somalie'),
('Baidoa', 'Baidoa', 'Somalie'),
('Galkayo', 'Galkayo', 'Somalie'),
('Beledweyne', 'Beledweyne', 'Somalie');

-- Afrique du Sud
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Johannesbourg', 'Johannesburg', 'Afrique du Sud'),
('Le Cap', 'Cape Town', 'Afrique du Sud'),
('Durban', 'Durban', 'Afrique du Sud'),
('Pretoria', 'Pretoria', 'Afrique du Sud'),
('Port Elizabeth', 'Port Elizabeth', 'Afrique du Sud'),
('Bloemfontein', 'Bloemfontein', 'Afrique du Sud'),
('Soweto', 'Soweto', 'Afrique du Sud'),
('East London', 'East London', 'Afrique du Sud'),
('Pietermaritzburg', 'Pietermaritzburg', 'Afrique du Sud'),
('Welkom', 'Welkom', 'Afrique du Sud');

-- Soudan du Sud
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Djouba', 'Juba', 'Soudan du Sud'),
('Malakal', 'Malakal', 'Soudan du Sud'),
('Wau', 'Wau', 'Soudan du Sud'),
('Yei', 'Yei', 'Soudan du Sud'),
('Aweil', 'Aweil', 'Soudan du Sud'),
('Bentiu', 'Bentiu', 'Soudan du Sud'),
('Rumbek', 'Rumbek', 'Soudan du Sud'),
('Kuacjok', 'Kuacjok', 'Soudan du Sud'),
('Gogrial', 'Gogrial', 'Soudan du Sud'),
('Yambio', 'Yambio', 'Soudan du Sud');

-- Soudan
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Khartoum', 'Khartoum', 'Soudan'),
('Omdourman', 'Omdurman', 'Soudan'),
('Nyala', 'Nyala', 'Soudan'),
('Port-Soudan', 'Port Sudan', 'Soudan'),
('Kassala', 'Kassala', 'Soudan'),
('Obeid', 'Obeid', 'Soudan'),
('Wad Madani', 'Wad Madani', 'Soudan'),
('Kosti', 'Kosti', 'Soudan'),
('Gedaref', 'Gedaref', 'Soudan'),
('Rabak', 'Rabak', 'Soudan');

-- Tanzanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Dar es Salam', 'Dar es Salaam', 'Tanzanie'),
('Mwanza', 'Mwanza', 'Tanzanie'),
('Arusha', 'Arusha', 'Tanzanie'),
('Dodoma', 'Dodoma', 'Tanzanie'),
('Mbeya', 'Mbeya', 'Tanzanie'),
('Morogoro', 'Morogoro', 'Tanzanie'),
('Tanga', 'Tanga', 'Tanzanie'),
('Zanzibar City', 'Zanzibar City', 'Tanzanie'),
('Kigoma', 'Kigoma', 'Tanzanie'),
('Moshi', 'Moshi', 'Tanzanie');

-- Togo
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lomé', 'Lomé', 'Togo'),
('Kpalimé', 'Kpalimé', 'Togo'),
('Atakpamé', 'Atakpamé', 'Togo'),
('Sokodé', 'Sokodé', 'Togo'),
('Kara', 'Kara', 'Togo'),
('Dapaong', 'Dapaong', 'Togo'),
('Tsévié', 'Tsévié', 'Togo'),
('Bassar', 'Bassar', 'Togo'),
('Aného', 'Aného', 'Togo'),
('Mango', 'Mango', 'Togo');

-- Zambie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lusaka', 'Lusaka', 'Zambie'),
('Kitwe', 'Kitwe', 'Zambie'),
('Ndola', 'Ndola', 'Zambie'),
('Kabwe', 'Kabwe', 'Zambie'),
('Chingola', 'Chingola', 'Zambie'),
('Mufulira', 'Mufulira', 'Zambie'),
('Luanshya', 'Luanshya', 'Zambie'),
('Livingstone', 'Livingstone', 'Zambie'),
('Kasama', 'Kasama', 'Zambie'),
('Chipata', 'Chipata', 'Zambie');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Hyères', 'Hyères', 'France'),
('Mantes-la-Jolie', 'Mantes-la-Jolie', 'France'),
('Châtellerault', 'Châtellerault', 'France'),
('Quimper', 'Quimper', 'France'),
('Vitrolles', 'Vitrolles', 'France'),
('Angoulême', 'Angouleme', 'France'),
('Chambéry', 'Chambery', 'France'),
('Montélimar', 'Montélimar', 'France'),
('Tarbes', 'Tarbes', 'France'),
('Arles', 'Arles', 'France'),
('Charleville-Mézières', 'Charleville-Mezieres', 'France'),
('Beauvais', 'Beauvais', 'France'),
('Laval', 'Laval', 'France'),
('Carcassonne', 'Carcassonne', 'France'),
('Auxerre', 'Auxerre', 'France'),
('Brive-la-Gaillarde', 'Brive-la-Gaillarde', 'France'),
('Mâcon', 'Mâcon', 'France'),
('Châlons-en-Champagne', 'Châlons-en-Champagne', 'France'),
('Valenciennes', 'Valenciennes', 'France'),
('Le Tampon', 'Le Tampon', 'Réunion'),
('Bastia', 'Bastia', 'France'),
('Albi', 'Albi', 'France'),
('Ajaccio', 'Ajaccio', 'France'),
('Maubeuge', 'Maubeuge', 'France'),
('Épinal', 'Épinal', 'France'),
('Épinay sur seine', 'Epinay sur seine', 'France'),
('Forbach', 'Forbach', 'France'),
('Savigny-sur-Orge', 'Savigny-sur-Orge', 'France'),
('Chalon-sur-Saône', 'Chalon-sur-Saône', 'France'),
('Sevran', 'Sevran', 'France'),
('Vierzon', 'Vierzon', 'France'),
('Choisy-le-Roi', 'Choisy-le-Roi', 'France');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tokyo', 'Tokyo', 'Japon'),
('Delhi', 'Delhi', 'Inde'),
('Shanghai', 'Shanghai', 'Chine'),
('Séoul', 'Seoul', 'Corée du Sud'),
('Pékin', 'Beijing', 'Chine'),
('Osaka', 'Osaka', 'Japon'),
('Bombay', 'Mumbai', 'Inde'),
('Chongqing', 'Chongqing', 'Chine'),
('Jakarta', 'Jakarta', 'Indonésie'),
('Guangzhou', 'Guangzhou', 'Chine'),
('Nanjing', 'Nanjing', 'Chine'),
('Tianjin', 'Tianjin', 'Chine'),
('Wuhan', 'Wuhan', 'Chine'),
('Bangkok', 'Bangkok', 'Thaïlande'),
('Ho Chi Minh Ville', 'Ho Chi Minh City', 'Vietnam'),
('Dhaka', 'Dhaka', 'Bangladesh'),
('Nagoya', 'Nagoya', 'Japon'),
('Shenyang', 'Shenyang', 'Chine'),
('Zhengzhou', 'Zhengzhou', 'Chine'),
('Changsha', 'Changsha', 'Chine'),
('Hangzhou', 'Hangzhou', 'Chine'),
('Kobe', 'Kobe', 'Japon'),
('Singapour', 'Singapore', 'Singapour'),
('Manille', 'Manila', 'Philippines'),
('Xi''an', 'Xi''an', 'Chine'),
('Chengdu', 'Chengdu', 'Chine'),
('Dalian', 'Dalian', 'Chine'),
('Dongguan', 'Dongguan', 'Chine'),
('Qingdao', 'Qingdao', 'Chine'),
('Foshan', 'Foshan', 'Chine'),
('Hongkou', 'Hongkou', 'Chine'),
('Jinan', 'Jinan', 'Chine'),
('Kawasaki', 'Kawasaki', 'Japon'),
('Kyoto', 'Kyoto', 'Japon'),
('Luoyang', 'Luoyang', 'Chine'),
('Ningbo', 'Ningbo', 'Chine'),
('Sapporo', 'Sapporo', 'Japon'),
('Taoyuan', 'Taoyuan', 'Taïwan'),
('Taizhou', 'Taizhou', 'Chine'),
('Tangshan', 'Tangshan', 'Chine'),
('Taipei', 'Taipei', 'Taïwan'),
('Tsingtao', 'Tsingtao', 'Chine'),
('Wenzhou', 'Wenzhou', 'Chine'),
('Xiamen', 'Xiamen', 'Chine'),
('Yantai', 'Yantai', 'Chine'),
('Yokohama', 'Yokohama', 'Japon'),
('Changchun', 'Changchun', 'Chine'),
('Changzhou', 'Changzhou', 'Chine'),
('Guiyang', 'Guiyang', 'Chine'),
('Harbin', 'Harbin', 'Chine'),
('Hefei', 'Hefei', 'Chine'),
('Ho Chi Minh Ville', 'Ho Chi Minh City', 'Vietnam'),
('Hong Kong', 'Hong Kong', 'Hong Kong'),
('Huainan', 'Huainan', 'Chine'),
('Hue', 'Hue', 'Vietnam'),
('Hyderabad', 'Hyderabad', 'Inde'),
('Kaohsiung', 'Kaohsiung', 'Taïwan'),
('Katmandou', 'Kathmandu', 'Népal'),
('Kunming', 'Kunming', 'Chine'),
('Lanzhou', 'Lanzhou', 'Chine'),
('Macau', 'Macau', 'Macau'),
('Malé', 'Malé', 'Maldives'),
('Nankin', 'Nanjing', 'Chine'),
('Nanning', 'Nanning', 'Chine'),
('Phnom Penh', 'Phnom Penh', 'Cambodge'),
('Qingdao', 'Qingdao', 'Chine'),
('Séoul', 'Seoul', 'Corée du Sud'),
('Shenzhen', 'Shenzhen', 'Chine'),
('Suzhou', 'Suzhou', 'Chine'),
('Taïpei', 'Taipei', 'Taïwan'),
('Tainan', 'Tainan', 'Taïwan'),
('Tashkent', 'Tashkent', 'Ouzbékistan'),
('Thimphou', 'Thimphu', 'Bhoutan'),
('Tianjin', 'Tianjin', 'Chine'),
('Ulaanbaatar', 'Ulaanbaatar', 'Mongolie'),
('Vladivostok', 'Vladivostok', 'Russie'),
('Xian', 'Xian', 'Chine'),
('Yamaguchi', 'Yamaguchi', 'Japon'),
('Yangon', 'Yangon', 'Myanmar'),
('Zhengzhou', 'Zhengzhou', 'Chine'),
('Abha', 'Abha', 'Arabie Saoudite'),
('Aleppo', 'Aleppo', 'Syrie'),
('Almaty', 'Almaty', 'Kazakhstan'),
('Amman', 'Amman', 'Jordanie'),
('Ankara', 'Ankara', 'Turquie'),
('Astana', 'Astana', 'Kazakhstan'),
('Bakou', 'Baku', 'Azerbaïdjan'),
('Balikpapan', 'Balikpapan', 'Indonésie'),
('Bandung', 'Bandung', 'Indonésie'),
('Batam', 'Batam', 'Indonésie'),
('Bauru', 'Bauru', 'Brésil'),
('Bekasi', 'Bekasi', 'Indonésie'),
('Bengaluru', 'Bengaluru', 'Inde'),
('Bijapur', 'Bijapur', 'Inde'),
('Bucaramanga', 'Bucaramanga', 'Colombie'),
('Cagayan de Oro', 'Cagayan de Oro', 'Philippines'),
('Calicut', 'Calicut', 'Inde'),
('Cebu', 'Cebu', 'Philippines'),
('Chongquing', 'Chongqing', 'Chine'),
('Colombo', 'Colombo', 'Sri Lanka'),
('Davao', 'Davao', 'Philippines'),
('Denpasar', 'Denpasar', 'Indonésie'),
('Djakarta', 'Jakarta', 'Indonésie'),
('Douchanbé', 'Dushanbe', 'Tadjikistan'),
('Erevan', 'Yerevan', 'Arménie'),
('Fukuoka', 'Fukuoka', 'Japon'),
('Gandhinagar', 'Gandhinagar', 'Inde'),
('Gérone', 'Girona', 'Espagne'),
('Gwangju', 'Gwangju', 'Corée du Sud'),
('Haikou', 'Haikou', 'Chine'),
('Haïphong', 'Haiphong', 'Vietnam'),
('Hanoj', 'Hanoi', 'Vietnam'),
('Hô Chi Minh Ville', 'Ho Chi Minh City', 'Vietnam'),
('Ipoh', 'Ipoh', 'Malaisie'),
('Ishukawa', 'Ishikawa', 'Japon'),
('Jaipur', 'Jaipur', 'Inde'),
('Jeju', 'Jeju', 'Corée du Sud'),
('Jeddah', 'Jeddah', 'Arabie Saoudite'),
('Johor Bahru', 'Johor Bahru', 'Malaisie'),
('Kaboul', 'Kabul', 'Afghanistan'),
('Kadhimain', 'Kadhimain', 'Irak'),
('Kalkutta', 'Kolkata', 'Inde'),
('Kamakura', 'Kamakura', 'Japon'),
('Kanpur', 'Kanpur', 'Inde'),
('Karachi', 'Karachi', 'Pakistan'),
('Kayseri', 'Kayseri', 'Turquie'),
('Kharkiv', 'Kharkiv', 'Ukraine'),
('Khartoum', 'Khartoum', 'Soudan'),
('Khonkaen', 'Khonkaen', 'Thaïlande'),
('Kobe', 'Kobe', 'Japon'),
('Konya', 'Konya', 'Turquie'),
('Kuala Lumpur', 'Kuala Lumpur', 'Malaisie'),
('Kuching', 'Kuching', 'Malaisie'),
('Kumamoto', 'Kumamoto', 'Japon'),
('Lahore', 'Lahore', 'Pakistan'),
('Makassar', 'Makassar', 'Indonésie'),
('Malabar', 'Malabar', 'Inde'),
('Manama', 'Manama', 'Bahreïn'),
('Manille', 'Manila', 'Philippines'),
('Mashhad', 'Mashhad', 'Iran'),
('Masjed-e-Soleiman', 'Masjed-e-Soleiman', 'Iran'),
('Medan', 'Medan', 'Indonésie'),
('Moscou', 'Moscow', 'Russie'),
('Nagasaki', 'Nagasaki', 'Japon'),
('Nagoya', 'Nagoya', 'Japon'),
('Nairobi', 'Nairobi', 'Kenya'),
('Najaf', 'Najaf', 'Irak'),
('Nouakchott', 'Nouakchott', 'Mauritanie'),
('Odessa', 'Odessa', 'Ukraine'),
('Osaka', 'Osaka', 'Japon'),
('Palembang', 'Palembang', 'Indonésie'),
('Palerme', 'Palermo', 'Italie'),
('Pékin', 'Beijing', 'Chine'),
('Pohang', 'Pohang', 'Corée du Sud'),
('Port-Louis', 'Port Louis', 'Île Maurice'),
('Pune', 'Pune', 'Inde'),
('Pyongyang', 'Pyongyang', 'Corée du Nord'),
('Qiqihar', 'Qiqihar', 'Chine'),
('Rawalpindi', 'Rawalpindi', 'Pakistan'),
('Riyad', 'Riyadh', 'Arabie Saoudite'),
('Sapporo', 'Sapporo', 'Japon'),
('Séoul', 'Seoul', 'Corée du Sud'),
('Shenzhen', 'Shenzhen', 'Chine'),
('Shiraz', 'Shiraz', 'Iran'),
('Siem Reap', 'Siem Reap', 'Cambodge'),
('Singapour', 'Singapore', 'Singapour'),
('Surabaya', 'Surabaya', 'Indonésie'),
('Surat', 'Surat', 'Inde'),
('Suwon', 'Suwon', 'Corée du Sud'),
('Tabriz', 'Tabriz', 'Iran'),
('Taïpei', 'Taipei', 'Taïwan'),
('Tanger', 'Tangier', 'Maroc'),
('Tashkent', 'Tashkent', 'Ouzbékistan'),
('Téhéran', 'Tehran', 'Iran'),
('Thimphou', 'Thimphu', 'Bhoutan'),
('Tianjin', 'Tianjin', 'Chine');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tomsk', 'Tomsk', 'Russie'),
('Tomé', 'Tome', 'Brésil'),

('Toyama', 'Toyama', 'Japon'),
('Tripoli', 'Tripoli', 'Libye'),
('Tsukuba', 'Tsukuba', 'Japon'),
('Ulaanbaatar', 'Ulaanbaatar', 'Mongolie'),
('Vladivostok', 'Vladivostok', 'Russie'),
('Wuhan', 'Wuhan', 'Chine'),
('Xiamen', 'Xiamen', 'Chine'),
('Xian', 'Xian', 'Chine'),
('Xianggang', 'Hong Kong', 'Hong Kong'),
('Yangon', 'Yangon', 'Myanmar'),
('Yekatérinbourg', 'Yekaterinburg', 'Russie'),
('Yeosu', 'Yeosu', 'Corée du Sud'),
('Yogyakarta', 'Yogyakarta', 'Indonésie');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Alger', 'Algiers', 'Algérie'),
('Oran', 'Oran', 'Algérie'),
('Constantine', 'Constantine', 'Algérie'),
('Annaba', 'Annaba', 'Algérie'),
('Blida', 'Blida', 'Algérie'),
('Batna', 'Batna', 'Algérie'),
('Djelfa', 'Djelfa', 'Algérie'),
('Sétif', 'Sétif', 'Algérie'),
('Sidi Bel Abbès', 'Sidi Bel Abbès', 'Algérie'),
('Biskra', 'Biskra', 'Algérie');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Luanda', 'Luanda', 'Angola'),
('Huambo', 'Huambo', 'Angola'),
('Lobito', 'Lobito', 'Angola'),
('Benguela', 'Benguela', 'Angola'),
('Kuito', 'Kuito', 'Angola'),
('Lubango', 'Lubango', 'Angola'),
('Malanje', 'Malanje', 'Angola'),
('Namibe', 'Namibe', 'Angola'),
('Soyo', 'Soyo', 'Angola'),
('Cabinda', 'Cabinda', 'Angola');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Cotonou', 'Cotonou', 'Bénin'),
('Abomey-Calavi', 'Abomey-Calavi', 'Bénin'),
('Djougou', 'Djougou', 'Bénin'),
('Porto-Novo', 'Porto-Novo', 'Bénin'),
('Parakou', 'Parakou', 'Bénin'),
('Bohicon', 'Bohicon', 'Bénin'),
('Kandi', 'Kandi', 'Bénin'),
('Lokossa', 'Lokossa', 'Bénin'),
('Ouidah', 'Ouidah', 'Bénin'),
('Natitingou', 'Natitingou', 'Bénin');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Gaborone', 'Gaborone', 'Botswana'),
('Francistown', 'Francistown', 'Botswana'),
('Maun', 'Maun', 'Botswana'),
('Serowe', 'Serowe', 'Botswana'),
('Molepolole', 'Molepolole', 'Botswana'),
('Kanye', 'Kanye', 'Botswana'),
('Mochudi', 'Mochudi', 'Botswana'),
('Mahalapye', 'Mahalapye', 'Botswana'),
('Mogoditshane', 'Mogoditshane', 'Botswana'),
('Palapye', 'Palapye', 'Botswana');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Ouagadougou', 'Ouagadougou', 'Burkina Faso'),
('Bobo-Dioulasso', 'Bobo-Dioulasso', 'Burkina Faso'),
('Koudougou', 'Koudougou', 'Burkina Faso'),
('Ouahigouya', 'Ouahigouya', 'Burkina Faso'),
('Banfora', 'Banfora', 'Burkina Faso'),
('Dédougou', 'Dédougou', 'Burkina Faso'),
('Kaya', 'Kaya', 'Burkina Faso'),
('Tenkodogo', 'Tenkodogo', 'Burkina Faso'),
('Dori', 'Dori', 'Burkina Faso');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bujumbura', 'Bujumbura', 'Burundi'),
('Gitega', 'Gitega', 'Burundi'),
('Muyinga', 'Muyinga', 'Burundi'),
('Ngozi', 'Ngozi', 'Burundi'),
('Ruyigi', 'Ruyigi', 'Burundi'),
('Kayanza', 'Kayanza', 'Burundi'),
('Bururi', 'Bururi', 'Burundi'),
('Rutana', 'Rutana', 'Burundi'),
('Makamba', 'Makamba', 'Burundi'),
('Muramvya', 'Muramvya', 'Burundi');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Douala', 'Douala', 'Cameroun'),
('Yaoundé', 'Yaoundé', 'Cameroun'),
('Garoua', 'Garoua', 'Cameroun'),
('Bamenda', 'Bamenda', 'Cameroun'),
('Maroua', 'Maroua', 'Cameroun'),
('Nkongsamba', 'Nkongsamba', 'Cameroun'),
('Bafoussam', 'Bafoussam', 'Cameroun'),
('Ngaoundéré', 'Ngaoundéré', 'Cameroun'),
('Bertoua', 'Bertoua', 'Cameroun'),
('Loum', 'Loum', 'Cameroun');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Praia', 'Praia', 'Cap-Vert'),
('Mindelo', 'Mindelo', 'Cap-Vert'),
('Santa Maria', 'Santa Maria', 'Cap-Vert'),
('Assomada', 'Assomada', 'Cap-Vert'),
('São Filipe', 'São Filipe', 'Cap-Vert'),
('Pedra Badejo', 'Pedra Badejo', 'Cap-Vert'),
('Porto Novo', 'Porto Novo', 'Cap-Vert'),
('Ribeira Brava', 'Ribeira Brava', 'Cap-Vert'),
('Tarrafal', 'Tarrafal', 'Cap-Vert'),
('Sal Rei', 'Sal Rei', 'Cap-Vert');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bangui', 'Bangui', 'République centrafricaine'),
('Bimbo', 'Bimbo', 'République centrafricaine'),
('Mbaïki', 'Mbaïki', 'République centrafricaine'),
('Berbérati', 'Berbérati', 'République centrafricaine'),
('Carnot', 'Carnot', 'République centrafricaine'),
('Bambari', 'Bambari', 'République centrafricaine'),
('Bouar', 'Bouar', 'République centrafricaine'),
('Bossangoa', 'Bossangoa', 'République centrafricaine'),
('Bria', 'Bria', 'République centrafricaine'),
('Kaga-Bandoro', 'Kaga-Bandoro', 'République centrafricaine');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Moundou', 'Moundou', 'Tchad'),
('Sarh', 'Sarh', 'Tchad'),
('Abéché', 'Abéché', 'Tchad'),
('Kelo', 'Kelo', 'Tchad'),
('Koumra', 'Koumra', 'Tchad'),
('Pala', 'Pala', 'Tchad'),
('Am Timan', 'Am Timan', 'Tchad'),
('Bongor', 'Bongor', 'Tchad'),
('Mongo', 'Mongo', 'Tchad');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Moroni', 'Moroni', 'Comores'),
('Mutsamudu', 'Mutsamudu', 'Comores'),
('Fomboni', 'Fomboni', 'Comores'),
('Domoni', 'Domoni', 'Comores'),
('Tsimbeo', 'Tsimbeo', 'Comores'),
('Ouani', 'Ouani', 'Comores'),
('Mitsoudjé', 'Mitsoudjé', 'Comores'),
('Mohéli', 'Mohéli', 'Comores'),
('Sima', 'Sima', 'Comores'),
('Koni-Djodjo', 'Koni-Djodjo', 'Comores');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Brazzaville', 'Brazzaville', 'République du Congo'),
('Pointe-Noire', 'Pointe-Noire', 'République du Congo'),
('Dolisie', 'Dolisie', 'République du Congo'),
('Nkayi', 'Nkayi', 'République du Congo'),
('Impfondo', 'Impfondo', 'République du Congo'),
('Ouesso', 'Ouesso', 'République du Congo'),
('Madingou', 'Madingou', 'République du Congo'),
('Sibiti', 'Sibiti', 'République du Congo'),
('Owando', 'Owando', 'République du Congo'),
('Mossendjo', 'Mossendjo', 'République du Congo');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kinshasa', 'Kinshasa', 'République démocratique du Congo'),
('Lubumbashi', 'Lubumbashi', 'République démocratique du Congo'),
('Mbuji-Mayi', 'Mbuji-Mayi', 'République démocratique du Congo'),
('Kananga', 'Kananga', 'République démocratique du Congo'),
('Kisangani', 'Kisangani', 'République démocratique du Congo'),
('Bukavu', 'Bukavu', 'République démocratique du Congo'),
('Goma', 'Goma', 'République démocratique du Congo'),
('Kolwezi', 'Kolwezi', 'République démocratique du Congo'),
('Likasi', 'Likasi', 'République démocratique du Congo'),
('Tshikapa', 'Tshikapa', 'République démocratique du Congo');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Abidjan', 'Abidjan', 'Côte d''Ivoire'),
('Bouaké', 'Bouaké', 'Côte d''Ivoire'),
('Daloa', 'Daloa', 'Côte d''Ivoire'),
('Korhogo', 'Korhogo', 'Côte d''Ivoire'),
('San-Pédro', 'San-Pédro', 'Côte d''Ivoire'),
('Yamoussoukro', 'Yamoussoukro', 'Côte d''Ivoire'),
('Gagnoa', 'Gagnoa', 'Côte d''Ivoire'),
('Man', 'Man', 'Côte d''Ivoire'),
('Divo', 'Divo', 'Côte d''Ivoire'),
('Abengourou', 'Abengourou', 'Côte d''Ivoire');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Djibouti', 'Djibouti', 'Djibouti'),
('Ali Sabieh', 'Ali Sabieh', 'Djibouti'),
('Tadjourah', 'Tadjourah', 'Djibouti'),
('Obock', 'Obock', 'Djibouti'),
('Dikhil', 'Dikhil', 'Djibouti'),
('Arta', 'Arta', 'Djibouti'),
('Holhol', 'Holhol', 'Djibouti'),
('Dorra', 'Dorra', 'Djibouti'),
('Yoboki', 'Yoboki', 'Djibouti'),
('As Eyla', 'As Eyla', 'Djibouti');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Le Caire', 'Cairo', 'Égypte'),
('Alexandrie', 'Alexandria', 'Égypte'),
('Gizeh', 'Giza', 'Égypte'),
('Shubra El-Kheima', 'Shubra El-Kheima', 'Égypte'),
('Port-Saïd', 'Port Said', 'Égypte'),
('Suez', 'Suez', 'Égypte'),
('Louxor', 'Luxor', 'Égypte'),
('Mansourah', 'Mansoura', 'Égypte'),
('Tanta', 'Tanta', 'Égypte');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Assouan', 'Aswan', 'Égypte');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Malabo', 'Malabo', 'Guinée équatoriale'),
('Bata', 'Bata', 'Guinée équatoriale'),
('Ebebiyin', 'Ebebiyin', 'Guinée équatoriale'),
('Mongomo', 'Mongomo', 'Guinée équatoriale'),
('Evinayong', 'Evinayong', 'Guinée équatoriale'),
('Luba', 'Luba', 'Guinée équatoriale'),
('Mbini', 'Mbini', 'Guinée équatoriale'),
('Mikomeseng', 'Mikomeseng', 'Guinée équatoriale'),
('Añisok', 'Añisok', 'Guinée équatoriale'),
('Nkimi', 'Nkimi', 'Guinée équatoriale');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Asmara', 'Asmara', 'Érythrée'),
('Keren', 'Keren', 'Érythrée'),
('Massaoua', 'Massawa', 'Érythrée'),
('Assab', 'Assab', 'Érythrée'),
('Mendefera', 'Mendefera', 'Érythrée'),
('Dekemhare', 'Dekemhare', 'Érythrée'),
('Adi Keyh', 'Adi Keyh', 'Érythrée'),
('Barentu', 'Barentu', 'Érythrée'),
('Adi Quala', 'Adi Quala', 'Érythrée'),
('Tsorona', 'Tsorona', 'Érythrée');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mbabane', 'Mbabane', 'Eswatini'),
('Manzini', 'Manzini', 'Eswatini'),
('Big Bend', 'Big Bend', 'Eswatini'),
('Malkerns', 'Malkerns', 'Eswatini'),
('Nhlangano', 'Nhlangano', 'Eswatini'),
('Piggs Peak', 'Piggs Peak', 'Eswatini'),
('Siteki', 'Siteki', 'Eswatini'),
('Hlatikulu', 'Hlatikulu', 'Eswatini'),
('Simunye', 'Simunye', 'Eswatini'),
('Mpaka', 'Mpaka', 'Eswatini');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Addis-Abeba', 'Addis Ababa', 'Éthiopie'),
('Dire Dawa', 'Dire Dawa', 'Éthiopie'),
('Mekele', 'Mekelle', 'Éthiopie'),
('Gondar', 'Gondar', 'Éthiopie'),
('Awasa', 'Awasa', 'Éthiopie'),
('Bahir Dar', 'Bahir Dar', 'Éthiopie'),
('Jimma', 'Jimma', 'Éthiopie'),
('Dessie', 'Dessie', 'Éthiopie'),
('Jijiga', 'Jijiga', 'Éthiopie'),
('Shashamane', 'Shashamane', 'Éthiopie');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Libreville', 'Libreville', 'Gabon'),
('Port-Gentil', 'Port-Gentil', 'Gabon'),
('Franceville', 'Franceville', 'Gabon'),
('Oyem', 'Oyem', 'Gabon'),
('Moanda', 'Moanda', 'Gabon'),
('Mouila', 'Mouila', 'Gabon'),
('Lambaréné', 'Lambaréné', 'Gabon'),
('Tchibanga', 'Tchibanga', 'Gabon'),
('Koulamoutou', 'Koulamoutou', 'Gabon'),
('Makokou', 'Makokou', 'Gabon');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Banjul', 'Banjul', 'Gambie'),
('Serekunda', 'Serekunda', 'Gambie'),
('Brikama', 'Brikama', 'Gambie'),
('Bakau', 'Bakau', 'Gambie'),
('Farafenni', 'Farafenni', 'Gambie'),
('Basse Santa Su', 'Basse Santa Su', 'Gambie'),
('Bansang', 'Bansang', 'Gambie'),
('Soma', 'Soma', 'Gambie'),
('Barra', 'Barra', 'Gambie'),
('Sukuta', 'Sukuta', 'Gambie');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Accra', 'Accra', 'Ghana'),
('Kumasi', 'Kumasi', 'Ghana'),
('Tamale', 'Tamale', 'Ghana'),
('Obuasi', 'Obuasi', 'Ghana'),
('Tema', 'Tema', 'Ghana'),
('Sekondi-Takoradi', 'Sekondi-Takoradi', 'Ghana'),
('Cape Coast', 'Cape Coast', 'Ghana'),
('Teshie', 'Teshie', 'Ghana'),
('Madina', 'Madina', 'Ghana'),
('Koforidua', 'Koforidua', 'Ghana');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Conakry', 'Conakry', 'Guinée'),
('Nzérékoré', 'Nzérékoré', 'Guinée'),
('Kankan', 'Kankan', 'Guinée'),
('Kindia', 'Kindia', 'Guinée'),
('Labé', 'Labé', 'Guinée'),
('Guéckédou', 'Guéckédou', 'Guinée'),
('Mamou', 'Mamou', 'Guinée'),
('Dabola', 'Dabola', 'Guinée'),
('Kamsar', 'Kamsar', 'Guinée'),
('Kissidougou', 'Kissidougou', 'Guinée');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bissau', 'Bissau', 'Guinée-Bissau'),
('Gabú', 'Gabú', 'Guinée-Bissau'),
('Bafatá', 'Bafatá', 'Guinée-Bissau'),
('Canchungo', 'Canchungo', 'Guinée-Bissau'),
('Bissorã', 'Bissorã', 'Guinée-Bissau'),
('Bolama', 'Bolama', 'Guinée-Bissau'),
('Catió', 'Catió', 'Guinée-Bissau'),
('Farim', 'Farim', 'Guinée-Bissau'),
('Bubaque', 'Bubaque', 'Guinée-Bissau'),
('Buba', 'Buba', 'Guinée-Bissau');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Nairobi', 'Nairobi', 'Kenya'),
('Mombasa', 'Mombasa', 'Kenya'),
('Kisumu', 'Kisumu', 'Kenya'),
('Nakuru', 'Nakuru', 'Kenya'),
('Eldoret', 'Eldoret', 'Kenya'),
('Thika', 'Thika', 'Kenya'),
('Malindi', 'Malindi', 'Kenya'),
('Kitale', 'Kitale', 'Kenya'),
('Kakamega', 'Kakamega', 'Kenya'),
('Nyeri', 'Nyeri', 'Kenya');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Monrovia', 'Monrovia', 'Liberia'),
('Gbarnga', 'Gbarnga', 'Liberia'),
('Kakata', 'Kakata', 'Liberia'),
('Bensonville', 'Bensonville', 'Liberia'),
('Harper', 'Harper', 'Liberia'),
('Voinjama', 'Voinjama', 'Liberia'),
('Buchanan', 'Buchanan', 'Liberia'),
('Zwedru', 'Zwedru', 'Liberia'),
('Robertsport', 'Robertsport', 'Liberia'),
('Greenville', 'Greenville', 'Liberia');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tripoli', 'Tripoli', 'Libye'),
('Benghazi', 'Benghazi', 'Libye'),
('Misrata', 'Misrata', 'Libye'),
('Bayda', 'Bayda', 'Libye'),
('Zawiya', 'Zawiya', 'Libye'),
('Ajdabiya', 'Ajdabiya', 'Libye'),
('Tobrouk', 'Tobruk', 'Libye'),
('Zintan', 'Zintan', 'Libye'),
('Sirte', 'Sirte', 'Libye'),
('Gharyan', 'Gharyan', 'Libye');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Antananarivo', 'Antananarivo', 'Madagascar'),
('Toamasina', 'Toamasina', 'Madagascar'),
('Antsirabe', 'Antsirabe', 'Madagascar'),
('Mahajanga', 'Mahajanga', 'Madagascar'),
('Fianarantsoa', 'Fianarantsoa', 'Madagascar'),
('Toliara', 'Toliara', 'Madagascar'),
('Antsiranana', 'Antsiranana', 'Madagascar'),
('Ambalavao', 'Ambalavao', 'Madagascar'),
('Tolagnaro', 'Tolagnaro', 'Madagascar'),
('Sambava', 'Sambava', 'Madagascar');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lilongwe', 'Lilongwe', 'Malawi'),
('Blantyre', 'Blantyre', 'Malawi'),
('Mzuzu', 'Mzuzu', 'Malawi'),
('Zomba', 'Zomba', 'Malawi'),
('Kasungu', 'Kasungu', 'Malawi'),
('Mangochi', 'Mangochi', 'Malawi'),
('Karonga', 'Karonga', 'Malawi'),
('Salima', 'Salima', 'Malawi'),
('Nkhotakota', 'Nkhotakota', 'Malawi'),
('Liwonde', 'Liwonde', 'Malawi');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Bamako', 'Bamako', 'Mali'),
('Sikasso', 'Sikasso', 'Mali'),
('Mopti', 'Mopti', 'Mali'),
('Koutiala', 'Koutiala', 'Mali'),
('Ségou', 'Ségou', 'Mali'),
('Kayes', 'Kayes', 'Mali'),
('Kati', 'Kati', 'Mali'),
('Gao', 'Gao', 'Mali'),
('San', 'San', 'Mali'),
('Kita', 'Kita', 'Mali');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Nouakchott', 'Nouakchott', 'Mauritanie'),
('Nouadhibou', 'Nouadhibou', 'Mauritanie'),
('Rosso', 'Rosso', 'Mauritanie'),
('Kaédi', 'Kaédi', 'Mauritanie'),
('Zouerate', 'Zouerate', 'Mauritanie'),
('Atar', 'Atar', 'Mauritanie'),
('Néma', 'Néma', 'Mauritanie'),
('Boutilimit', 'Boutilimit', 'Mauritanie'),
('Aleg', 'Aleg', 'Mauritanie'),
('Sélibabi', 'Sélibabi', 'Mauritanie');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Port-Louis', 'Port Louis', 'Île Maurice'),
('Beau Bassin-Rose Hill', 'Beau Bassin-Rose Hill', 'Île Maurice'),
('Vacoas-Phoenix', 'Vacoas-Phoenix', 'Île Maurice'),
('Curepipe', 'Curepipe', 'Île Maurice'),
('Quatre Bornes', 'Quatre Bornes', 'Île Maurice'),
('Triolet', 'Triolet', 'Île Maurice'),
('Goodlands', 'Goodlands', 'Île Maurice'),
('Mahébourg', 'Mahébourg', 'Île Maurice'),
('Flacq', 'Flacq', 'Île Maurice'),
('Rivière du Rempart', 'Rivière du Rempart', 'Île Maurice');

INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mamoudzou', 'Mamoudzou', 'Mayotte'),
('Koungou', 'Koungou', 'Mayotte'),
('Dzaoudzi', 'Dzaoudzi', 'Mayotte'),
('Dembeni', 'Dembeni', 'Mayotte'),
('Sada', 'Sada', 'Mayotte'),
('Bandrélé', 'Bandrélé', 'Mayotte'),
('Pamandzi', 'Pamandzi', 'Mayotte'),
('Bouéni', 'Bouéni', 'Mayotte'),
('Chiconi', 'Chiconi', 'Mayotte'),
('Ouangani', 'Ouangani', 'Mayotte');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Casablanca', 'Casablanca', 'Maroc'),
('Rabat', 'Rabat', 'Maroc'),
('Fès', 'Fez', 'Maroc'),
('Marrakech', 'Marrakesh', 'Maroc'),
('Tanger', 'Tangier', 'Maroc'),
('Meknès', 'Meknes', 'Maroc'),
('Agadir', 'Agadir', 'Maroc'),
('Oujda', 'Oujda', 'Maroc'),
('Kénitra', 'Kenitra', 'Maroc'),
('Tétouan', 'Tetouan', 'Maroc');

-- Mozambique
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Maputo', 'Maputo', 'Mozambique'),
('Matola', 'Matola', 'Mozambique'),
('Beira', 'Beira', 'Mozambique'),
('Nampula', 'Nampula', 'Mozambique'),
('Chimoio', 'Chimoio', 'Mozambique'),
('Nacala', 'Nacala', 'Mozambique'),
('Quelimane', 'Quelimane', 'Mozambique'),
('Tete', 'Tete', 'Mozambique'),
('Xai-Xai', 'Xai-Xai', 'Mozambique'),
('Gurue', 'Gurue', 'Mozambique');

-- Namibie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Windhoek', 'Windhoek', 'Namibie'),
('Rundu', 'Rundu', 'Namibie'),
('Walvis Bay', 'Walvis Bay', 'Namibie'),
('Oshakati', 'Oshakati', 'Namibie'),
('Swakopmund', 'Swakopmund', 'Namibie'),
('Katima Mulilo', 'Katima Mulilo', 'Namibie'),
('Grootfontein', 'Grootfontein', 'Namibie'),
('Rehoboth', 'Rehoboth', 'Namibie'),
('Otjiwarongo', 'Otjiwarongo', 'Namibie'),
('Okahandja', 'Okahandja', 'Namibie');

-- Niger
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Niamey', 'Niamey', 'Niger'),
('Zinder', 'Zinder', 'Niger'),
('Maradi', 'Maradi', 'Niger'),
('Agadez', 'Agadez', 'Niger'),
('Tahoua', 'Tahoua', 'Niger'),
('Arlit', 'Arlit', 'Niger'),
('Dosso', 'Dosso', 'Niger'),
('Tillabéri', 'Tillabéri', 'Niger'),
('Diffa', 'Diffa', 'Niger'),
('Gaya', 'Gaya', 'Niger');

-- Nigeria
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lagos', 'Lagos', 'Nigeria'),
('Kano', 'Kano', 'Nigeria'),
('Ibadan', 'Ibadan', 'Nigeria'),
('Abuja', 'Abuja', 'Nigeria'),
('Port Harcourt', 'Port Harcourt', 'Nigeria'),
('Benin City', 'Benin City', 'Nigeria'),
('Maiduguri', 'Maiduguri', 'Nigeria'),
('Zaria', 'Zaria', 'Nigeria'),
('Aba', 'Aba', 'Nigeria'),
('Jos', 'Jos', 'Nigeria');

-- Ouganda
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kampala', 'Kampala', 'Ouganda'),
('Gulu', 'Gulu', 'Ouganda'),
('Lira', 'Lira', 'Ouganda'),
('Mbarara', 'Mbarara', 'Ouganda'),
('Jinja', 'Jinja', 'Ouganda'),
('Bwizibwera', 'Bwizibwera', 'Ouganda'),
('Mbale', 'Mbale', 'Ouganda'),
('Mukono', 'Mukono', 'Ouganda'),
('Kasese', 'Kasese', 'Ouganda'),
('Masaka', 'Masaka', 'Ouganda');

-- Rwanda
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Kigali', 'Kigali', 'Rwanda'),
('Butare', 'Butare', 'Rwanda'),
('Gitarama', 'Gitarama', 'Rwanda'),
('Musanze', 'Musanze', 'Rwanda'),
('Gisenyi', 'Gisenyi', 'Rwanda'),
('Byumba', 'Byumba', 'Rwanda'),
('Cyangugu', 'Cyangugu', 'Rwanda'),
('Kibungo', 'Kibungo', 'Rwanda'),
('Kibuye', 'Kibuye', 'Rwanda'),
('Ruhengeri', 'Ruhengeri', 'Rwanda');

-- Sao Tomé-et-Principe
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('São Tomé', 'São Tomé', 'Sao Tomé-et-Principe'),
('Santo António', 'Santo António', 'Sao Tomé-et-Principe'),
('Neves', 'Neves', 'Sao Tomé-et-Principe'),
('Santana', 'Santana', 'Sao Tomé-et-Principe'),
('Trindade', 'Trindade', 'Sao Tomé-et-Principe'),
('Guadalupe', 'Guadalupe', 'Sao Tomé-et-Principe'),
('Madalena', 'Madalena', 'Sao Tomé-et-Principe'),
('Bombom', 'Bombom', 'Sao Tomé-et-Principe'),
('Santa Cruz', 'Santa Cruz', 'Sao Tomé-et-Principe'),
('Ribeira Afonso', 'Ribeira Afonso', 'Sao Tomé-et-Principe');

-- Sénégal
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Dakar', 'Dakar', 'Sénégal'),
('Thiès', 'Thiès', 'Sénégal'),
('Rufisque', 'Rufisque', 'Sénégal'),
('Kaolack', 'Kaolack', 'Sénégal'),
('Ziguinchor', 'Ziguinchor', 'Sénégal'),
('Saint-Louis', 'Saint-Louis', 'Sénégal'),
('Mbour', 'Mbour', 'Sénégal'),
('Diourbel', 'Diourbel', 'Sénégal'),
('Louga', 'Louga', 'Sénégal'),
('Tambacounda', 'Tambacounda', 'Sénégal');

-- Seychelles
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Victoria', 'Victoria', 'Seychelles'),
('Anse Boileau', 'Anse Boileau', 'Seychelles'),
('Bel Ombre', 'Bel Ombre', 'Seychelles'),
('Beau Vallon', 'Beau Vallon', 'Seychelles'),
('Cascade', 'Cascade', 'Seychelles'),
('Grand Anse', 'Grand Anse', 'Seychelles'),
('Baie Lazare', 'Baie Lazare', 'Seychelles'),
('La Digue', 'La Digue', 'Seychelles'),
('Anse Royale', 'Anse Royale', 'Seychelles'),
('Takamaka', 'Takamaka', 'Seychelles');

-- Sierra Leone
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Freetown', 'Freetown', 'Sierra Leone'),
('Bo', 'Bo', 'Sierra Leone'),
('Kenema', 'Kenema', 'Sierra Leone'),
('Makeni', 'Makeni', 'Sierra Leone'),
('Koidu', 'Koidu', 'Sierra Leone'),
('Waterloo', 'Waterloo', 'Sierra Leone'),
('Port Loko', 'Port Loko', 'Sierra Leone'),
('Lunsar', 'Lunsar', 'Sierra Leone'),
('Kailahun', 'Kailahun', 'Sierra Leone'),
('Bonthe', 'Bonthe', 'Sierra Leone');

-- Somalie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Mogadiscio', 'Mogadishu', 'Somalie'),
('Hargeisa', 'Hargeisa', 'Somalie'),
('Bosaso', 'Bosaso', 'Somalie'),
('Kismayo', 'Kismayo', 'Somalie'),
('Berbera', 'Berbera', 'Somalie'),
('Marka', 'Marka', 'Somalie'),
('Burao', 'Burao', 'Somalie'),
('Baidoa', 'Baidoa', 'Somalie'),
('Galkayo', 'Galkayo', 'Somalie'),
('Beledweyne', 'Beledweyne', 'Somalie');

-- Afrique du Sud
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Johannesbourg', 'Johannesburg', 'Afrique du Sud'),
('Le Cap', 'Cape Town', 'Afrique du Sud'),
('Durban', 'Durban', 'Afrique du Sud'),
('Pretoria', 'Pretoria', 'Afrique du Sud'),
('Port Elizabeth', 'Port Elizabeth', 'Afrique du Sud'),
('Bloemfontein', 'Bloemfontein', 'Afrique du Sud'),
('Soweto', 'Soweto', 'Afrique du Sud'),
('East London', 'East London', 'Afrique du Sud'),
('Pietermaritzburg', 'Pietermaritzburg', 'Afrique du Sud'),
('Welkom', 'Welkom', 'Afrique du Sud');

-- Soudan du Sud
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Djouba', 'Juba', 'Soudan du Sud'),
('Malakal', 'Malakal', 'Soudan du Sud'),
('Wau', 'Wau', 'Soudan du Sud'),
('Yei', 'Yei', 'Soudan du Sud'),
('Aweil', 'Aweil', 'Soudan du Sud'),
('Bentiu', 'Bentiu', 'Soudan du Sud'),
('Rumbek', 'Rumbek', 'Soudan du Sud'),
('Kuacjok', 'Kuacjok', 'Soudan du Sud'),
('Gogrial', 'Gogrial', 'Soudan du Sud'),
('Yambio', 'Yambio', 'Soudan du Sud');

-- Soudan
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Khartoum', 'Khartoum', 'Soudan'),
('Omdourman', 'Omdurman', 'Soudan'),
('Nyala', 'Nyala', 'Soudan'),
('Port-Soudan', 'Port Sudan', 'Soudan'),
('Kassala', 'Kassala', 'Soudan'),
('Obeid', 'Obeid', 'Soudan'),
('Wad Madani', 'Wad Madani', 'Soudan'),
('Kosti', 'Kosti', 'Soudan'),
('Gedaref', 'Gedaref', 'Soudan'),
('Rabak', 'Rabak', 'Soudan');

-- Tanzanie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Dar es Salam', 'Dar es Salaam', 'Tanzanie'),
('Mwanza', 'Mwanza', 'Tanzanie'),
('Arusha', 'Arusha', 'Tanzanie'),
('Dodoma', 'Dodoma', 'Tanzanie'),
('Mbeya', 'Mbeya', 'Tanzanie'),
('Morogoro', 'Morogoro', 'Tanzanie'),
('Tanga', 'Tanga', 'Tanzanie'),
('Zanzibar City', 'Zanzibar City', 'Tanzanie'),
('Kigoma', 'Kigoma', 'Tanzanie'),
('Moshi', 'Moshi', 'Tanzanie');

-- Togo
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lomé', 'Lomé', 'Togo'),
('Kpalimé', 'Kpalimé', 'Togo'),
('Atakpamé', 'Atakpamé', 'Togo'),
('Sokodé', 'Sokodé', 'Togo'),
('Kara', 'Kara', 'Togo'),
('Dapaong', 'Dapaong', 'Togo'),
('Tsévié', 'Tsévié', 'Togo'),
('Bassar', 'Bassar', 'Togo'),
('Aného', 'Aného', 'Togo'),
('Mango', 'Mango', 'Togo');

-- Zambie
INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Lusaka', 'Lusaka', 'Zambie'),
('Kitwe', 'Kitwe', 'Zambie'),
('Ndola', 'Ndola', 'Zambie'),
('Kabwe', 'Kabwe', 'Zambie'),
('Chingola', 'Chingola', 'Zambie'),
('Mufulira', 'Mufulira', 'Zambie'),
('Luanshya', 'Luanshya', 'Zambie'),
('Livingstone', 'Livingstone', 'Zambie');


INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr)
SELECT DISTINCT nom_ville_fr, nom_ville_en, nom_pays_fr
FROM (
    VALUES
    ('Marseille', 'Marseille', 'France'),
    ('Lyon', 'Lyon', 'France'),
    ('Paris','Paris','France'),
    ('Nice', 'Nice', 'France'),
    ('Nantes', 'Nantes', 'France'),
    ('Strasbourg', 'Strasbourg', 'France'),
    ('Montpellier', 'Montpellier', 'France'),
    ('Bordeaux', 'Bordeaux', 'France'),
    ('Lille', 'Lille', 'France'),
    ('Rennes', 'Rennes', 'France'),
    ('Reims', 'Reims', 'France'),
    ('Le Havre', 'Le Havre', 'France'),
    ('Saint-Étienne', 'Saint-Etienne', 'France'),
    ('Toulon', 'Toulon', 'France'),
    ('Grenoble', 'Grenoble', 'France'),
    ('Dijon', 'Dijon', 'France'),
    ('Angers', 'Angers', 'France'),
    ('Villeurbanne', 'Villeurbanne', 'France'),
    ('Le Mans', 'Le Mans', 'France'),
    ('Aix-en-Provence', 'Aix-en-Provence', 'France'),
    ('Brest', 'Brest', 'France'),
    ('Nîmes', 'Nîmes', 'France'),
    ('Clermont-Ferrand', 'Clermont-Ferrand', 'France'),
    ('Limoges', 'Limoges', 'France'),
    ('Avignon', 'Avignon', 'France'),
    ('Saint-Denis', 'Saint-Denis', 'France'),
    ('Argenteuil', 'Argenteuil', 'France'),
    ('Rouen', 'Rouen', 'France'),
    ('Saint-Paul', 'Saint-Paul', 'France'),
    ('Dunkerque', 'Dunkerque', 'France'),
    ('Vitry-sur-Seine', 'Vitry-sur-Seine', 'France'),
    ('Créteil', 'Créteil', 'France'),
    ('Pau', 'Pau', 'France'),
    ('Poitiers', 'Poitiers', 'France'),
    ('Perpignan', 'Perpignan', 'France'),
    ('Metz', 'Metz', 'France'),
    ('Béthune', 'Béthune', 'France'),
    ('Orléans', 'Orléans', 'France'),
    ('Mulhouse', 'Mulhouse', 'France'),
    ('Caen', 'Caen', 'France'),
    ('Saint-Maur-des-Fossés', 'Saint-Maur-des-Fosses', 'France'),
    ('Champigny-sur-Marne', 'Champigny-sur-Marne', 'France'),
    ('Valence', 'Valence', 'France'),
    ('Tourcoing', 'Tourcoing', 'France'),
    ('Aulnay-sous-Bois', 'Aulnay-sous-Bois', 'France'),
    ('Cherbourg-en-Cotentin', 'Cherbourg-en-Cotentin', 'France'),
    ('Amiens', 'Amiens', 'France'),
    ('Mamoudzou', 'Mamoudzou', 'Mayotte'),
    ('Aubervilliers', 'Aubervilliers', 'France'),
    ('Montreuil', 'Montreuil', 'France'),
    ('Saint-Pierre', 'Saint-Pierre', 'Réunion'),
    ('Calais', 'Calais', 'France'),
    ('Cannes', 'Cannes', 'France'),
    ('Boulogne-Billancourt', 'Boulogne-Billancourt', 'France'),
    ('Agen', 'Agen', 'France'),
    ('Asnières-sur-Seine', 'Asnieres-sur-Seine', 'France'),
    ('Levallois-Perret', 'Levallois-Perret', 'France'),
    ('Versailles', 'Versailles', 'France'),
    ('Courbevoie', 'Courbevoie', 'France'),
    ('Saint-Nazaire', 'Saint-Nazaire', 'France'),
    ('Rueil-Malmaison', 'Rueil-Malmaison', 'France'),
    ('Colombes', 'Colombes', 'France'),
    ('Nanterre', 'Nanterre', 'France'),
    ('Roubaix', 'Roubaix', 'France'),
    ('Pessac', 'Pessac', 'France'),
    ('Noisy-le-Grand', 'Noisy-le-Grand', 'France'),
    ('Lorient', 'Lorient', 'France'),
    ('Évry', 'Évry', 'France'),
    ('Troyes', 'Troyes', 'France'),
    ('Bourges', 'Bourges', 'France'),
    ('Drancy', 'Drancy', 'France'),
    ('Antibes', 'Antibes', 'France'),
    ('Saint-Quentin', 'Saint-Quentin', 'France'),
    ('La Rochelle', 'La Rochelle', 'France'),
    ('Neuilly-sur-Seine', 'Neuilly-sur-Seine', 'France'),
    ('Avignon', 'Avignon', 'France'),
    ('Antony', 'Antony', 'France'),
    ('Clichy', 'Clichy', 'France'),
    ('Saint-Louis', 'Saint-Louis', 'France'),
    ('Grasse', 'Grasse', 'France'),
    ('Béziers', 'Béziers', 'France'),
    ('Fontenay-sous-Bois', 'Fontenay-sous-Bois', 'France'),
    ('Sarcelles', 'Sarcelles', 'France'),
    ('Meaux', 'Meaux', 'France'),
    ('Villeneuve-d''Ascq', 'Villeneuve-d''Ascq', 'France'),
    ('Saint-André', 'Saint-André', 'France'),
    ('Villejuif', 'Villejuif', 'France'),
    ('Niort', 'Niort', 'France'),
    ('Vénissieux', 'Vénissieux', 'France'),
    ('Cayenne', 'Cayenne', 'Guyane'),
    ('Cholet', 'Cholet', 'France'),
    ('Montauban', 'Montauban', 'France'),
    ('Colmar', 'Colmar', 'France'),
    ('Pantin', 'Pantin', 'France'),
    ('Évreux', 'Évreux', 'France'),
    ('Blois', 'Blois', 'France'),
    ('Boulogne-sur-Mer', 'Boulogne-sur-Mer', 'France'),
    ('Élisabeth', 'Élisabeth', 'France'),
    ('Vannes', 'Vannes', 'France'),
    ('Brétigny-sur-Orge', 'Bretigny-sur-Orge', 'France'),
    ('Thionville', 'Thionville', 'France'),
    ('Saint-Brieuc', 'Saint-Brieuc', 'France'),
    ('Hyères', 'Hyères', 'France'),
    ('Mantes-la-Jolie', 'Mantes-la-Jolie', 'France'),
    ('Châtellerault', 'Châtellerault', 'France'),
    ('Quimper', 'Quimper', 'France'),
    ('Vitrolles', 'Vitrolles', 'France'),
    ('Angoulême', 'Angoulême', 'France'),
    ('Chambéry', 'Chambéry', 'France'),
    ('Montélimar', 'Montélimar', 'France'),
    ('Tarbes', 'Tarbes', 'France'),
    ('Arles', 'Arles', 'France'),
    ('Charleville-Mézières', 'Charleville-Mézières', 'France'),
    ('Beauvais', 'Beauvais', 'France'),
    ('Laval', 'Laval', 'France'),
    ('Carcassonne', 'Carcassonne', 'France'),
    ('Auxerre', 'Auxerre', 'France'),
    ('Brive-la-Gaillarde', 'Brive-la-Gaillarde', 'France'),
    ('Mâcon', 'Mâcon', 'France'),
    ('Châlons-en-Champagne', 'Châlons-en-Champagne', 'France'),
    ('Valenciennes', 'Valenciennes', 'France'),
    ('Le Tampon', 'Le Tampon', 'Réunion'),
    ('Bastia', 'Bastia', 'France'),
    ('Albi', 'Albi', 'France'),
    ('Ajaccio', 'Ajaccio', 'France'),
    ('Maubeuge', 'Maubeuge', 'France'),
    ('Épinal', 'Épinal', 'France'),
    ('Forbach', 'Forbach', 'France'),
    ('Savigny-sur-Orge', 'Savigny-sur-Orge', 'France'),
    ('Chalon-sur-Saône', 'Chalon-sur-Saône', 'France'),
    ('Sevran', 'Sevran', 'France'),
    ('Vierzon', 'Vierzon', 'France'),
    ('Choisy-le-Roi', 'Choisy-le-Roi', 'France')
) AS t (nom_ville_fr, nom_ville_en, nom_pays_fr);



INSERT INTO bf_ville (nom_ville_fr, nom_ville_en, nom_pays_fr) VALUES
('Tunis', 'Tunis', 'Tunisie'),
('Sfax', 'Sfax', 'Tunisie'),
('Sousse', 'Sousse', 'Tunisie'),
('Kairouan', 'Kairouan', 'Tunisie'),
('Gabès', 'Gabès', 'Tunisie'),
('Bizerte', 'Bizerte', 'Tunisie'),
('Nabeul', 'Nabeul', 'Tunisie'),
('Monastir', 'Monastir', 'Tunisie'),
('Kasserine', 'Kasserine', 'Tunisie'),
('Gafsa', 'Gafsa', 'Tunisie'),
('Tozeur', 'Tozeur', 'Tunisie'),
('Kébili', 'Kébili', 'Tunisie'),
('Tataouine', 'Tataouine', 'Tunisie'),
('Médenine', 'Médenine', 'Tunisie'),
('Sidi Bouzid', 'Sidi Bouzid', 'Tunisie'),
('Kef', 'Kef', 'Tunisie'),
('Mahdia', 'Mahdia', 'Tunisie'),
('Jendouba', 'Jendouba', 'Tunisie'),
('Siliana', 'Siliana', 'Tunisie'),
('Zaghouan', 'Zaghouan', 'Tunisie'),
('Béja', 'Béja', 'Tunisie'),
('Sidi Bou Saïd', 'Sidi Bou Saïd', 'Tunisie'),
('La Marsa', 'La Marsa', 'Tunisie'),
('Djerba', 'Djerba', 'Tunisie'),
('Hammamet', 'Hammamet', 'Tunisie'),
('Port El Kantaoui', 'Port El Kantaoui', 'Tunisie'),
('Tabarka', 'Tabarka', 'Tunisie'),
('Zarzis', 'Zarzis', 'Tunisie'),
('Ksar Hellal', 'Ksar Hellal', 'Tunisie'),
('Menzel Bourguiba', 'Menzel Bourguiba', 'Tunisie'),
('Korba', 'Korba', 'Tunisie'),
('Jerba', 'Jerba', 'Tunisie'),
('Douz', 'Douz', 'Tunisie'),
('El Jem', 'El Jem', 'Tunisie'),
('Matmata', 'Matmata', 'Tunisie'),
('Kerkennah', 'Kerkennah', 'Tunisie'),
('Sbeitla', 'Sbeitla', 'Tunisie'),
('Thala', 'Thala', 'Tunisie'),
('Nefta', 'Nefta', 'Tunisie'),
('Midoun', 'Midoun', 'Tunisie'),
('Djerba-Houmt Souk', 'Djerba-Houmt Souk', 'Tunisie'),
('Mornag', 'Mornag', 'Tunisie'),
('Oueslatia', 'Oueslatia', 'Tunisie'),
('Regueb', 'Regueb', 'Tunisie'),
('Makthar', 'Makthar', 'Tunisie'),
('Skhira', 'Skhira', 'Tunisie'),
('El Hamma', 'El Hamma', 'Tunisie'),
('Bir Ali Ben Khalifa', 'Bir Ali Ben Khalifa', 'Tunisie'),
('Sidi Aïch', 'Sidi Aïch', 'Tunisie'),
('Galaat El Andeless', 'Galaat El Andeless', 'Tunisie');



CREATE INDEX idx_nom_ville_fr ON bf_ville(nom_ville_fr);
CREATE INDEX idx_nom_ville_en ON bf_ville(nom_ville_en);
CREATE INDEX idx_ville_nom_pays_fr ON bf_ville(nom_pays_fr);


---------------- groupe sanguin -------------------------------
DROP TABLE IF EXISTS bf_groupe_sanguin CASCADE;
CREATE TABLE bf_groupe_sanguin (
    id SERIAL PRIMARY KEY,
    groupe VARCHAR(4) NOT NULL
);

INSERT INTO bf_groupe_sanguin (groupe) VALUES 
('A'),
('A+'),
('A-'),
('B'),
('B+'),
('B-'),
('AB'),
('AB+'),
('AB-'),
('O'),
('O+'),
('O-');

CREATE INDEX idx_groupe_sanguin ON bf_groupe_sanguin(groupe);



---------------- civilitye -------------------------------
DROP TABLE IF EXISTS bf_civilite CASCADE;
CREATE TABLE bf_civilite (
    id SERIAL PRIMARY KEY,
    civilite VARCHAR(15) NOT NULL
);

INSERT INTO bf_civilite(civilite) VALUES 
('Mr'),
('Mme'),
('Mlle'),
('Dr'),
('Pr'),
('Monsieur'),
('Madame'),
('Mademoiselle');

CREATE INDEX idx_bf_civilite ON bf_civilite(civilite);