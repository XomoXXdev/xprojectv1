-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Feb 26. 10:00
-- Kiszolgáló verziója: 10.4.22-MariaDB
-- PHP verzió: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `xproject`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `attachments`
--

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `data` varchar(255) COLLATE utf8_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `backfire`
--

CREATE TABLE `backfire` (
  `id` int(11) NOT NULL,
  `vehicle` int(11) NOT NULL,
  `isbackfire` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bank`
--

CREATE TABLE `bank` (
  `id` int(11) NOT NULL,
  `position` varchar(300) NOT NULL DEFAULT '',
  `type` set('ped','atm') NOT NULL DEFAULT 'ped',
  `skin` int(11) NOT NULL DEFAULT 0,
  `name` varchar(300) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bank_transaction`
--

CREATE TABLE `bank_transaction` (
  `id` int(11) NOT NULL,
  `type` varchar(200) NOT NULL DEFAULT '',
  `targetnumber` varchar(300) NOT NULL DEFAULT '',
  `ownernumber` varchar(300) NOT NULL DEFAULT '',
  `amount` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `serial` varchar(200) NOT NULL,
  `admin` varchar(200) NOT NULL DEFAULT 'Unknown',
  `reason` varchar(300) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `defaulthours` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `bee`
--

CREATE TABLE `bee` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `b_pos` varchar(200) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT -1,
  `bees` int(11) NOT NULL DEFAULT 0,
  `used` int(11) NOT NULL DEFAULT 0,
  `extractor` int(11) NOT NULL DEFAULT 0,
  `collectable` int(11) NOT NULL DEFAULT 0,
  `inside` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `bee`
--

INSERT INTO `bee` (`id`, `type`, `b_pos`, `owner`, `bees`, `used`, `extractor`, `collectable`, `inside`) VALUES
(12, 1, '[ [ -643.74609375, 935.8505859375, 12.1328125, 0, 0, 90.43807983398438, 0, 0 ] ]', 20, 0, 0, 0, 0, 0),
(13, 1, '[ [ -643.6416015625, 937.9794921875, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 16, 5, 0, 1, 0, 0),
(14, 1, '[ [ -643.625, 940.1494140625, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 20, 5, 0, 0, 0, 0),
(15, 2, '[ [ -643.60546875, 942.810546875, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 127, 1, 0, 0, 0, 0),
(16, 1, '[ [ -643.5849609375, 945.521484375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 126, 1, 0, 0, 0, 0),
(17, 0, '[ [ -643.56640625, 948.0693359375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(18, 1, '[ [ -643.5478515625, 950.6318359375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 147, 1, 0, 0, 0, 0),
(19, 0, '[ [ -643.5263671875, 953.490234375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(20, 0, '[ [ -643.505859375, 956.2890625, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(21, 0, '[ [ -643.4892578125, 958.478515625, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(22, 0, '[ [ -643.470703125, 961.0185546875, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(23, 0, '[ [ -643.4560546875, 962.9287109375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(24, 0, '[ [ -643.439453125, 965.1943359375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(25, 0, '[ [ -643.42578125, 966.99609375, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(26, 1, '[ [ -643.408203125, 969.36328125, 12.1328125, 0, 0, 359.5687561035156, 0, 0 ] ]', 308, 0, 0, 1, 1, 0),
(27, 2, '[ [ -643.6455078125, 971.4375, 12.12872505187988, 0, 0, 4.897216796875, 0, 0 ] ]', 90, 2, 0, 1, 0, 0),
(28, 1, '[ [ -643.8291015625, 973.5810546875, 12.12872505187988, 0, 0, 4.897216796875, 0, 0 ] ]', 90, 1, 0, 1, 0, 0),
(29, 1, '[ [ -644.20703125, 977.98828125, 12.1328125, 0, 0, 4.897216796875, 0, 0 ] ]', 23, 0, 0, 0, 0, 0),
(30, 1, '[ [ -647.166015625, 935.216796875, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 14, 5, 0, 1, 0, 0),
(31, 2, '[ [ -647.28125, 937.3896484375, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 12, 5, 0, 0, 0, 0),
(32, 2, '[ [ -647.41796875, 940.009765625, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 65, 5, 0, 1, 0, 0),
(33, 1, '[ [ -647.568359375, 942.84375, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 65, 5, 3, 1, 1, 0),
(34, 1, '[ [ -647.712890625, 945.58203125, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 34, 2, 0, 0, 0, 0),
(35, 1, '[ [ -647.8603515625, 948.3818359375, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 128, 2, 0, 0, 0, 0),
(36, 2, '[ [ -648, 951.03125, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 127, 1, 0, 0, 0, 0),
(37, 0, '[ [ -648.1357421875, 953.611328125, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(38, 0, '[ [ -648.2841796875, 956.43359375, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(39, 0, '[ [ -648.419921875, 959.015625, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', -1, 0, 0, 0, 0, 0),
(40, 1, '[ [ -648.80078125, 962.7919921875, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', 171, 5, 0, 1, 0, 0),
(41, 1, '[ [ -648.921875, 965.0947265625, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', 172, 5, 0, 1, 0, 0),
(42, 1, '[ [ -649.0166015625, 966.8916015625, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', 172, 5, 0, 1, 0, 0),
(43, 2, '[ [ -649.1474609375, 969.3876953125, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', 171, 5, 0, 1, 0, 0),
(44, 0, '[ [ -649.2890625, 972.07421875, 12.12872505187988, 0, 0, 3.018524169921875, 0, 0 ] ]', 88, 0, 0, 0, 0, 0),
(45, 3, '[ [ -649.474609375, 975.6015625, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 88, 3, 1, 1, 1, 0),
(46, 3, '[ [ -649.619140625, 978.3310546875, 12.1328125, 0, 0, 3.018524169921875, 0, 0 ] ]', 90, 1, 0, 1, 1, 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `clothes`
--

CREATE TABLE `clothes` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `objectid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT 'Ruha',
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` int(11) NOT NULL,
  `ry` int(11) NOT NULL,
  `rz` int(11) NOT NULL,
  `scale` int(11) NOT NULL,
  `boneid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `clotheses`
--

CREATE TABLE `clotheses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL DEFAULT 0,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `rotx` int(11) NOT NULL DEFAULT 0,
  `roty` int(11) NOT NULL DEFAULT 0,
  `rotz` int(11) NOT NULL DEFAULT 0,
  `sz` int(11) NOT NULL,
  `bone` int(11) NOT NULL,
  `sx` int(11) NOT NULL,
  `sy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `clotheses`
--

INSERT INTO `clotheses` (`id`, `owner`, `model`, `x`, `y`, `z`, `rotx`, `roty`, `rotz`, `sz`, `bone`, `sx`, `sy`) VALUES
(1, 185, 16015, 0, 0.048, 0.122, 0, 0, 0, 1, 1, 1, 1),
(2, 185, 7570, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1),
(3, 185, 8607, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `extras`
--

CREATE TABLE `extras` (
  `dbid` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `modelid` int(11) NOT NULL DEFAULT 0,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `rotx` float NOT NULL DEFAULT 0,
  `roty` float NOT NULL DEFAULT 0,
  `rotz` float NOT NULL DEFAULT 0,
  `height` int(11) NOT NULL DEFAULT 0,
  `widght` int(11) NOT NULL DEFAULT 0,
  `avalible` varchar(11) NOT NULL DEFAULT 'false',
  `bone` int(11) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `farmelements`
--

CREATE TABLE `farmelements` (
  `id` int(11) NOT NULL,
  `increase` int(11) NOT NULL,
  `water` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `field` int(11) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `y` int(110) NOT NULL,
  `z` int(110) NOT NULL,
  `intinterior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `farms`
--

CREATE TABLE `farms` (
  `id` int(10) NOT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `rotation` float DEFAULT NULL,
  `owner` int(11) DEFAULT 0,
  `locked` tinyint(4) NOT NULL DEFAULT 0,
  `cost` int(15) DEFAULT 0,
  `name` varchar(255) DEFAULT 'Farm',
  `blockTable` mediumtext DEFAULT NULL,
  `permissionTable` mediumtext DEFAULT NULL,
  `rentTime` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `farms`
--

INSERT INTO `farms` (`id`, `x`, `y`, `z`, `rotation`, `owner`, `locked`, `cost`, `name`, `blockTable`, `permissionTable`, `rentTime`) VALUES
(106, 1140.08, 1224.74, 10.8203, 27.7931, 5, 0, 0, 'Marcus Dave\n', '[ [ { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 0, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": true, \"blockRow\": 0, \"plantSize\": 0, \"plantIndex\": 0, \"plantHelathChanger\": 100, \"changingTime\": 4500, \"wateringTick\": 0, \"healthRemainingTime\": 3600000, \"plantHealth\": 100, \"wateringState\": false, \"changingValue\": 100, \"newState\": \"land_hole\", \"waterLevel\": 0, \"waterChanger\": 0, \"newStateSaveLevel\": 0, \"sizeChanger\": 0, \"healthTick\": 0, \"blockColumn\": 2, \"state\": \"land_cultivated\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 1011117, \"newStateLevel\": 0, \"plantTick\": 0, \"waterLossTime\": 3600000 }, { \"changingState\": false, \"blockRow\": 0, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 0, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 0, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 1, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 1, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 1, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 1, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 1, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 2, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 2, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 2, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 2, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 2, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 3, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 3, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 3, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 3, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 3, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 4, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 4, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 4, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 4, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 4, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 5, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 5, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 5, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 5, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 5, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 6, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 6, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 6, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 6, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 6, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 7, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 7, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 7, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 7, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 7, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 8, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 8, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 8, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 8, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 8, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 9, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 1, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 9, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 2, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"changingState\": false, \"blockRow\": 9, \"wateringState\": false, \"changingSlot\": 0, \"changingTime\": 0, \"healthRemainingTime\": 3600000, \"changingValue\": 0, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"newStateLevel\": 0, \"state\": false, \"blockColumn\": 3, \"plantHealth\": 100, \"healthTick\": 0, \"changingTick\": 0, \"wateringTick\": 0, \"waterLevel\": 0, \"waterLossTime\": 3600000 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 9, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 4, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 }, { \"plantTimer\": 2100000, \"changingState\": false, \"blockRow\": 9, \"plantSize\": 0, \"plantIndex\": 0, \"changingSlot\": 0, \"changingTime\": 0, \"wateringTick\": 0, \"plantHealth\": 100, \"healthRemainingTime\": 3600000, \"wateringState\": false, \"waterLossTime\": 3600000, \"changingValue\": 0, \"newState\": false, \"newStateSaveLevel\": 0, \"waterChanger\": 0, \"healthTick\": 0, \"sizeChanger\": 0, \"blockColumn\": 5, \"plantHelathChanger\": 100, \"state\": \"land\", \"plantObject\": 0, \"plantFullSize\": 1, \"waterLossTick\": 0, \"changingTick\": 0, \"waterLevel\": 0, \"plantTick\": 0, \"newStateLevel\": 0 } ] ]', '[ [ ] ]', 604270401);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `fuels`
--

CREATE TABLE `fuels` (
  `position` varchar(255) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `gates`
--

CREATE TABLE `gates` (
  `dbid` int(255) NOT NULL,
  `object` int(255) NOT NULL DEFAULT 0,
  `x1` float NOT NULL DEFAULT 0,
  `y1` float NOT NULL DEFAULT 0,
  `z1` float NOT NULL DEFAULT 0,
  `rotx1` float NOT NULL DEFAULT 0,
  `roty1` float NOT NULL DEFAULT 0,
  `rotz1` float NOT NULL DEFAULT 0,
  `x2` float NOT NULL DEFAULT 0,
  `y2` float NOT NULL DEFAULT 0,
  `z2` float NOT NULL DEFAULT 0,
  `rotx2` float NOT NULL DEFAULT 0,
  `roty2` float NOT NULL DEFAULT 0,
  `rotz2` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `groups`
--

CREATE TABLE `groups` (
  `id` int(11) NOT NULL,
  `type` set('ambulance','law','maffia','gang','mechanic','fired','other') NOT NULL DEFAULT 'other',
  `name` varchar(200) NOT NULL,
  `ranks` varchar(999) NOT NULL DEFAULT '[ [ [ "rank1", 0 ], [ "rank2", 0 ], [ "rank3", 0 ], [ "rank4", 0 ], [ "rank5", 0 ], [ "rank6", 0 ], [ "rank7", 0 ], [ "rank8", 0 ], [ "rank9", 0 ], [ "rank10", 0 ], [ "rank11", 0 ], [ "rank12", 0 ], [ "rank13", 0 ], [ "rank14", 0 ], [ "rank15", 0 ] ] ]',
  `items` text NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `description` varchar(255) NOT NULL DEFAULT 'Nincs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `groups`
--

INSERT INTO `groups` (`id`, `type`, `name`, `ranks`, `items`, `money`, `description`) VALUES
(1, 'law', 'LVPD', '[ [ [ \"rank1\", 0 ], [ \"rank2\", 0 ], [ \"rank3\", 0 ], [ \"rank4\", 0 ], [ \"rank5\", 0 ], [ \"rank6\", 0 ], [ \"rank7\", 0 ], [ \"rank8\", 0 ], [ \"rank9\", 0 ], [ \"rank10\", 0 ], [ \"rank11\", 0 ], [ \"rank12\", 0 ], [ \"rank13\", 0 ], [ \"rank14\", 0 ], [ \"rank15\", 0 ] ] ]', '', 15000, 'Nincs'),
(2, 'mechanic', 'LVTS', '[ [ [ \"rank1\", 0 ], [ \"rank2\", 0 ], [ \"rank3\", 0 ], [ \"rank4\", 0 ], [ \"rank5\", 0 ], [ \"rank6\", 0 ], [ \"rank7\", 0 ], [ \"rank8\", 0 ], [ \"rank9\", 0 ], [ \"rank10\", 0 ], [ \"rank11\", 0 ], [ \"rank12\", 0 ], [ \"rank13\", 0 ], [ \"rank14\", 0 ], [ \"rank15\", 0 ] ] ]', '', 1500, 'Nincs');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `groups_players`
--

CREATE TABLE `groups_players` (
  `id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `groupid` int(11) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 1,
  `leader` int(11) NOT NULL DEFAULT 0,
  `skin` int(11) NOT NULL DEFAULT 0,
  `cardnumber` varchar(300) NOT NULL DEFAULT '',
  `lastonline` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `groups_players`
--

INSERT INTO `groups_players` (`id`, `uid`, `groupid`, `rank`, `leader`, `skin`, `cardnumber`, `lastonline`) VALUES
(94, 5, 1, 1, 1, 281, '', '2022-02-24 14:36:57'),
(95, 6, 1, 1, 0, 280, '', '2022-02-22 20:26:41');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `groups_transactions`
--

CREATE TABLE `groups_transactions` (
  `id` int(11) NOT NULL,
  `groupid` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `name` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'nil',
  `type` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'nil',
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `interiors`
--

CREATE TABLE `interiors` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `intx` float NOT NULL,
  `inty` float NOT NULL,
  `intz` float NOT NULL,
  `intinterior` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `name` varchar(300) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT -1,
  `price` int(11) NOT NULL DEFAULT 0,
  `garagesize` int(11) NOT NULL DEFAULT -1,
  `renttime` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `interiors`
--

INSERT INTO `interiors` (`id`, `x`, `y`, `z`, `interior`, `dimension`, `intx`, `inty`, `intz`, `intinterior`, `locked`, `type`, `name`, `owner`, `price`, `garagesize`, `renttime`) VALUES
(383, 1040.11, 1303.88, 10.8203, 0, 0, -794.806, 497.738, 1376.2, 1, 0, 2, 'LVTS', -1, 0, -1, 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `interiors2`
--

CREATE TABLE `interiors2` (
  `id` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `intx` float NOT NULL,
  `inty` float NOT NULL,
  `intz` float NOT NULL,
  `intinterior` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `name` varchar(300) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT -1,
  `price` int(11) NOT NULL DEFAULT 0,
  `garagesize` int(11) NOT NULL DEFAULT -1,
  `renttime` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- A tábla adatainak kiíratása `interiors2`
--

INSERT INTO `interiors2` (`id`, `x`, `y`, `z`, `interior`, `dimension`, `intx`, `inty`, `intz`, `intinterior`, `locked`, `type`, `name`, `owner`, `price`, `garagesize`, `renttime`) VALUES
(1, -1597.9, 1741.59, 8.76523, 0, 0, -29.1748, -87.8995, 965.894, 18, 0, 1, '1', 2, 1, -1, 1624149553),
(1, -1597.9, 1741.59, 8.76523, 0, 0, -29.1748, -87.8995, 965.894, 18, 0, 1, '1', 2, 1, -1, 1624149553),
(1, -1597.9, 1741.59, 8.76523, 0, 0, -29.1748, -87.8995, 965.894, 18, 0, 1, '1', 2, 1, -1, 1624149553),
(1, -1597.9, 1741.59, 8.76523, 0, 0, -29.1748, -87.8995, 965.894, 18, 0, 1, '1', 2, 1, -1, 1624149553);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 1,
  `type` set('bag','key','licens','vehicle','object') NOT NULL DEFAULT 'bag',
  `slot` int(11) NOT NULL DEFAULT -1,
  `item` int(11) NOT NULL DEFAULT -1,
  `value` varchar(300) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT 1,
  `dutyitem` int(11) NOT NULL DEFAULT 0,
  `state` int(11) NOT NULL DEFAULT 100,
  `weaponserial` varchar(300) NOT NULL DEFAULT 'Unknown',
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `items`
--

INSERT INTO `items` (`id`, `owner`, `type`, `slot`, `item`, `value`, `count`, `dutyitem`, `state`, `weaponserial`, `created`) VALUES
(1, 1, 'key', 1, 105, '2', 1, 0, 100, 'Unknown', '2022-02-10 17:19:30'),
(2, 1, 'key', 2, 105, '3', 1, 0, 100, 'Unknown', '2022-02-10 17:19:57'),
(4, 1, 'licens', 1, 120, '[ { \"num1\": 127056, \"num2\": 4, \"money\": 0, \"charid\": 1, \"used\": false, \"pincode\": 1234 } ]', 1, 0, 100, 'Unknown', '2022-02-10 18:44:44'),
(5, 1, 'licens', 2, 120, '[ { \"num1\": 127056, \"num2\": 5, \"money\": 0, \"charid\": 1, \"used\": false, \"pincode\": 1234 } ]', 1, 0, 100, 'Unknown', '2022-02-10 18:45:05'),
(6, 1, 'key', 3, 106, '1', 1, 0, 100, 'Unknown', '2022-02-10 19:12:42'),
(16, 6, 'bag', 1, 135, '100', 1, 0, 100, 'Unknown', '2022-02-18 20:23:45'),
(21, 5, 'key', 1, 105, '9', 1, 0, 100, 'Unknown', '2022-02-19 16:45:15'),
(22, 5, 'key', 2, 105, '10', 1, 0, 100, 'Unknown', '2022-02-19 16:58:06'),
(24, 5, 'bag', 5, 133, '1343944', 1, 0, 1, 'Unknown', '2022-02-20 17:06:15'),
(31, 6, 'bag', 2, 122, '1', 1, 0, 100, 'Unknown', '2022-02-20 17:44:57'),
(32, 5, 'bag', 6, 127, 'Police Officer', 1, 0, 100, 'LSPD', '2022-02-20 18:16:46'),
(33, 5, 'bag', 7, 21, '100', 1, 0, 100, 'Unknown', '2022-02-20 19:39:45'),
(34, 5, 'bag', 8, 22, '100', 88, 0, 100, 'Unknown', '2022-02-20 19:39:51'),
(37, 6, 'bag', 3, 133, '455992', 1, 0, 1, 'Unknown', '2022-02-20 19:43:44'),
(38, 5, 'bag', 1, 149, '1', 1, 0, 100, 'Unknown', '2022-02-20 19:51:43'),
(39, 6, 'bag', 4, 149, '1', 1, 0, 100, 'Unknown', '2022-02-20 19:52:20'),
(41, 7, 'bag', 2, 133, '1343944', 1, 0, 1, 'Unknown', '2022-02-22 16:00:24'),
(42, 6, 'bag', 5, 23, '1', 1, 0, 100, 'Unknown', '2022-02-22 18:42:03'),
(43, 6, 'bag', 6, 24, '1000', 470, 0, 100, 'Unknown', '2022-02-22 18:42:22'),
(47, 6, 'bag', 7, 126, '1', 1, 0, 100, 'Unknown', '2022-02-22 19:01:13'),
(48, 6, 'key', 1, 105, '11', 1, 0, 100, 'Unknown', '2022-02-22 19:02:16'),
(49, 6, 'bag', 8, 25, '1', 1, 0, 100, 'Unknown', '2022-02-22 19:05:29'),
(50, 6, 'bag', 9, 27, '1000', 991, 0, 100, 'Unknown', '2022-02-22 19:05:41'),
(51, 6, 'key', 2, 105, '12', 1, 0, 100, 'Unknown', '2022-02-22 19:11:06'),
(54, 6, 'licens', 1, 136, '1', 1, 0, 0, 'Unknown', '2022-02-22 19:44:38');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `items_actionbar`
--

CREATE TABLE `items_actionbar` (
  `id` int(11) NOT NULL,
  `slot` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  `itemdbid` int(11) NOT NULL DEFAULT 0,
  `item` int(11) NOT NULL DEFAULT 0,
  `category` varchar(200) NOT NULL DEFAULT 'bag',
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `items_actionbar`
--

INSERT INTO `items_actionbar` (`id`, `slot`, `owner`, `itemdbid`, `item`, `category`, `created`) VALUES
(35, 1, 6, 16, 135, 'bag', '2022-02-18 20:25:50'),
(37, 1, 7, 17, 135, 'bag', '2022-02-22 15:55:44'),
(39, 2, 7, 41, 133, 'bag', '2022-02-22 16:00:31'),
(40, 1, 5, 24, 133, 'bag', '2022-02-22 16:05:52'),
(41, 2, 5, 33, 21, 'bag', '2022-02-22 18:41:37'),
(42, 2, 6, 42, 23, 'bag', '2022-02-22 18:42:30'),
(43, 3, 6, 49, 25, 'bag', '2022-02-22 19:05:50'),
(45, 4, 6, 47, 126, 'bag', '2022-02-22 19:11:52');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `phonemessages`
--

CREATE TABLE `phonemessages` (
  `recievedPhone` int(11) NOT NULL,
  `senderPhone` int(11) NOT NULL,
  `messageData` varchar(255) CHARACTER SET latin1 NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `phonemessages`
--

INSERT INTO `phonemessages` (`recievedPhone`, `senderPhone`, `messageData`, `id`) VALUES
(455992, 1343944, '[ [ [ [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\" ], [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\", true ], [ \"0122-01-22 18:06\", \"asdasdasd\" ], [ \"0122-01-22 18:06\", \"asdasdasd\", true ] ], true ] ]', 0),
(1343944, 455992, '[ [ [ [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\" ], [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\", true ], [ \"0122-01-22 18:06\", \"asdasdasd\" ], [ \"0122-01-22 18:06\", \"asdasdasd\", true ] ], true ] ]', 0),
(1343944, 1343944, '[ [ [ [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\" ], [ \"0122-01-22 18:06\", \"sdfsdfsdfsdf\", true ], [ \"0122-01-22 18:06\", \"asdasdasd\" ], [ \"0122-01-22 18:06\", \"asdasdasd\", true ] ], true ] ]', 0);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `roulettes`
--

CREATE TABLE `roulettes` (
  `id` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `z` int(11) NOT NULL,
  `rz` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- A tábla adatainak kiíratása `roulettes`
--

INSERT INTO `roulettes` (`id`, `x`, `y`, `z`, `rz`, `interior`, `dimension`) VALUES
(1, 1954, 1039, 993, 89, 10, 103),
(2, 1930, 1039, 995, 360, 10, 103),
(3, 1930, 1048, 995, 3, 10, 103),
(4, 1936, 994, 993, 180, 10, 103),
(5, 2000, 1007, 995, 269, 10, 103),
(6, 1993, 1007, 995, 271, 10, 103),
(7, 2000, 1029, 995, 89, 10, 103),
(8, 1992, 1029, 995, 91, 10, 103),
(9, 1976, 1039, 995, 191, 10, 103),
(10, 1970, 1051, 995, 214, 10, 103),
(11, 2193, 1034, 80, 114, 0, 0),
(12, 1950, 1042, 993, 180, 10, 109),
(13, 1958, 1036, 993, 359, 10, 109),
(14, 1936, 1035, 993, 179, 10, 109);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `safes`
--

CREATE TABLE `safes` (
  `id` int(11) NOT NULL,
  `position` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `serials`
--

CREATE TABLE `serials` (
  `id` int(11) NOT NULL,
  `serial` varchar(32) NOT NULL,
  `charid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `serials`
--

INSERT INTO `serials` (`id`, `serial`, `charid`) VALUES
(1, '7B6A1D6A9803DFA75530E7520C712E71', 1),
(2, 'E68C07BDAE43D447B90CEC60A57D19B4', 4),
(3, 'DDDE3F9618064709825F1A009677A094', 6);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `shop_peds`
--

CREATE TABLE `shop_peds` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL,
  `skin` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL,
  `typename` varchar(100) NOT NULL DEFAULT '',
  `items` varchar(500) NOT NULL DEFAULT '[ [  ] ]',
  `money` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `shop_peds`
--

INSERT INTO `shop_peds` (`id`, `owner`, `x`, `y`, `z`, `rotation`, `interior`, `dimension`, `skin`, `name`, `typename`, `items`, `money`) VALUES
(56, 5, 2181.84, 2584.01, 6.76562, 31, 0, 0, 1, 'teszt', '', '[ [ [ 133, 200, 1, 1, 13 ] ] ]', 113),
(58, 5, 1067.63, 1356.17, 10.7209, 217, 0, 0, 1, 'Lofasz', 'asd', '[ [ [ 133, 200, 1, 21, 200 ] ] ]', 195820);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `smslog`
--

CREATE TABLE `smslog` (
  `id` int(11) NOT NULL,
  `user` varchar(100) NOT NULL,
  `amount` int(10) NOT NULL DEFAULT 0,
  `country` varchar(100) NOT NULL,
  `sender` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `trash`
--

CREATE TABLE `trash` (
  `id` int(11) NOT NULL,
  `position` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `trash`
--

INSERT INTO `trash` (`id`, `position`) VALUES
(2, '[ [ 1671.521484375, 1796.6025390625, 10.8203125, 0, 0, 79.25933837890625, 0, 0 ] ]'),
(4, '[ [ 1049.7177734375, 1042.947265625, 10.18002891540527, 0, 0, 254.4005432128906, 0, 0 ] ]');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `charname` varchar(40) NOT NULL DEFAULT 'notreg',
  `adminname` varchar(255) NOT NULL DEFAULT 'Admin',
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `serial` varchar(32) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `admin` int(11) NOT NULL DEFAULT 0,
  `helper` int(11) NOT NULL DEFAULT 0,
  `playedminutes` int(11) NOT NULL DEFAULT 0,
  `paytime` int(11) NOT NULL DEFAULT 60,
  `x` float NOT NULL DEFAULT 1021.46,
  `y` float NOT NULL DEFAULT 1077.58,
  `z` float NOT NULL DEFAULT 11,
  `rotation` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `height` int(11) NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 0,
  `age` int(11) NOT NULL DEFAULT 0,
  `description` varchar(300) NOT NULL DEFAULT '',
  `money` int(11) NOT NULL DEFAULT 2600,
  `premium` int(11) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 100,
  `armor` int(11) NOT NULL DEFAULT 100,
  `hunger` int(11) NOT NULL DEFAULT 100,
  `thirsty` int(11) NOT NULL DEFAULT 100,
  `skin` int(11) NOT NULL DEFAULT 0,
  `dutyskin` int(11) NOT NULL DEFAULT 0,
  `induty` varchar(255) NOT NULL DEFAULT 'false',
  `banned` int(11) NOT NULL DEFAULT 0,
  `bannedby` varchar(200) NOT NULL DEFAULT 'Admin',
  `bannedreason` varchar(200) NOT NULL DEFAULT 'Default',
  `created` varchar(300) NOT NULL DEFAULT 'notdate',
  `skills` varchar(300) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `level` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `username`, `charname`, `adminname`, `password`, `email`, `serial`, `ip`, `admin`, `helper`, `playedminutes`, `paytime`, `x`, `y`, `z`, `rotation`, `interior`, `dimension`, `height`, `weight`, `age`, `description`, `money`, `premium`, `health`, `armor`, `hunger`, `thirsty`, `skin`, `dutyskin`, `induty`, `banned`, `bannedby`, `bannedreason`, `created`, `skills`, `level`) VALUES
(4, 'lolman66', 'Noe Cadly', 'Zack', 'DD56FCC6404FA7C167127A789D9BEC23', 'whfu@gmail.com', 'E68C07BDAE43D447B90CEC60A57D19B4', '89.133.192.238', 11, 0, 0, 60, 2839.65, 2649.18, 10.6719, 0, 0, 0, 187, 88, 21, 'aaaaaaaaaaaaaaaaaaaaaaaaa', 2600, 0, 100, 100, 100, 100, 2, 0, 'false', 0, 'Admin', 'Default', '2022.02.13', '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 1),
(5, 'XomoXX', 'Marcus Dave', 'XomoXX', 'D6239F5888987FF271D6D631E2F19D40', 'info@xomoxx.hu', '7B6A1D6A9803DFA75530E7520C712E71', '89.165.150.99', 10, 0, 0, 60, 1679.8, 1713.82, 10.6719, 0, 0, 0, 182, 76, 32, 'asdasdasdasdasd', 789829, 0, 100, 100, 100, 100, 23, 0, 'false', 0, 'Admin', 'Default', '2022.02.13', '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 15),
(6, 'lolman666', 'Lakatos_Ronaldo', 'Zack', 'DD56FCC6404FA7C167127A789D9BEC23', 'wi fuhwfuhuhf@gamil.hu', 'DDDE3F9618064709825F1A009677A094', '89.133.192.238', 11, 0, 0, 60, 1821.44, 1877.68, 7.44366, 0, 0, 0, 188, 88, 21, 'aaaaaaaaaaaaaaaaaaaaaaaaa', 2144379157, 0, 84, 100, 94, 100, 1, 0, 'false', 0, 'Admin', 'Default', '2022.02.16', '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 99),
(7, 'timikeakotonszoke', 'Adolf Hitler', 'Admin', 'A4EFFBFADB1AE3078BEFD4654EF61244', 'timikeakotonszokeveny@gmail.com', '1E07814A5EE8962896ED581FBB57AB52', '46.214.17.146', 0, 0, 0, 60, -783.866, 491.639, 1376.2, 0, 1, 383, 200, 69, 32, '696969696969696969696969', 2250, 0, 81, 100, 98, 100, 1, 0, 'false', 0, 'Admin', 'Default', '2022.02.22', '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT -1,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` int(11) DEFAULT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT -1,
  `group` int(11) NOT NULL DEFAULT -1,
  `locked` int(11) NOT NULL DEFAULT 0,
  `engine` int(11) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 0,
  `miles` int(11) NOT NULL DEFAULT 0,
  `panels` varchar(35) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `doors` varchar(35) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `wheels` varchar(35) NOT NULL DEFAULT '[ [ 0, 0, 0, 0 ] ]',
  `color` varchar(200) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `plate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `vehicles`
--

INSERT INTO `vehicles` (`id`, `model`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `interior`, `dimension`, `owner`, `group`, `locked`, `engine`, `health`, `fuel`, `miles`, `panels`, `doors`, `wheels`, `color`, `plate`) VALUES
(3, 436, 1683, 1790.79, 10.8203, 0, 0, NULL, 0, 0, 1, 0, 0, 0, 1000, 100, 0, '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 109, 108, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 0),
(11, 445, 1671.44, 1786.64, 10.8203, 0, 0, NULL, 0, 0, 6, 0, 0, 0, 1000, 100, 0, '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0, 0, 0 ] ]', '[ [ 0, 0, 0, 0 ] ]', '[ [ 132, 4, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', 0);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `bank`
--
ALTER TABLE `bank`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `bank_transaction`
--
ALTER TABLE `bank_transaction`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `extras`
--
ALTER TABLE `extras`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `farms`
--
ALTER TABLE `farms`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`dbid`);

--
-- A tábla indexei `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `groups_players`
--
ALTER TABLE `groups_players`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `groups_transactions`
--
ALTER TABLE `groups_transactions`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `interiors`
--
ALTER TABLE `interiors`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `items_actionbar`
--
ALTER TABLE `items_actionbar`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `safes`
--
ALTER TABLE `safes`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `serials`
--
ALTER TABLE `serials`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `shop_peds`
--
ALTER TABLE `shop_peds`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `trash`
--
ALTER TABLE `trash`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `bank`
--
ALTER TABLE `bank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `bank_transaction`
--
ALTER TABLE `bank_transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=192;

--
-- AUTO_INCREMENT a táblához `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT a táblához `extras`
--
ALTER TABLE `extras`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `farms`
--
ALTER TABLE `farms`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT a táblához `gates`
--
ALTER TABLE `gates`
  MODIFY `dbid` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT a táblához `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `groups_players`
--
ALTER TABLE `groups_players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT a táblához `groups_transactions`
--
ALTER TABLE `groups_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT a táblához `interiors`
--
ALTER TABLE `interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=384;

--
-- AUTO_INCREMENT a táblához `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT a táblához `items_actionbar`
--
ALTER TABLE `items_actionbar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT a táblához `safes`
--
ALTER TABLE `safes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT a táblához `serials`
--
ALTER TABLE `serials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `shop_peds`
--
ALTER TABLE `shop_peds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT a táblához `trash`
--
ALTER TABLE `trash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
