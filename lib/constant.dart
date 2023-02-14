import 'package:nameum_types/nameum_types.dart';

List<Store> rests = [
  Store(
      storeName: "역전할매맥주",
      tables: {1: 0},
      detailDesc: "좋은 곳 입니다.",
      mainImage: "images/newMenu.jpg",
      thumbnail: "images/grandma.jpg",
      storeId: "6wteBwHq84hQooJrDlDd",
      owner: "",
      address: defaultAddress),
  Store(
      storeName: "삼구포차",
      tables: {1: 0},
      detailDesc: "좋은 입니다.",
      mainImage: "images/39.png",
      thumbnail: "images/grandma.jpg",
      storeId: "2",
      owner: "",
      address: defaultAddress),
  Store(
      storeName: "역전매맥주",
      tables: {1: 0},
      detailDesc: "좋은 곳",
      mainImage: "images/newMenu.jpg",
      thumbnail: "images/grandma.jpg",
      storeId: "3",
      owner: "",
      address: defaultAddress),
];
const Address defaultAddress = Address(
  roadAddr: "서울특별시 마포구 성암로 301(상암동)",
  roadAddrPart1: "서울특별시 마포구 성암로 301",
  roadAddrPart2: "(상암동)",
  engAddr: "301 Seongam-ro, Mapo-gu, Seoul",
  jibunAddr: "서울특별시 마포구 상암동 1595 한국지역정보개발원(KLID Tower)",
  zipNo: "03923",
  admCd: "1144012700",
  rnMgtSn: "114403113012",
  bdMgtSn: "1144012700115950000000001",
  detBdNmList: "한국지역정보개발원",
  bdNm: "한국지역정보개발원(KLID Tower)",
  bdKdcd: "0",
  siNm: "서울특별시",
  sggNm: "마포구",
  emdNm: "상암동",
  liNm: "",
  rn: "성암로",
  udrtYn: "0",
  buldMnnm: "301",
  buldSlno: "0",
  mtYn: "0",
  lnbrMnnm: "1595",
  lnbrSlno: "0",
  emdNo: "03",
);
String mapIconsPath = 'images/map_icons';
Map<StoreCategory, String> categoryToPath = {
  StoreCategory.korean: 'images/map_icons/korean.png',
  StoreCategory.chinese: 'images/map_icons/chinese.png',
  StoreCategory.japanese: 'images/map_icons/japanese.png',
  StoreCategory.snack: 'images/map_icons/snack.png',
  StoreCategory.chicken: 'images/map_icons/chicken.png',
  StoreCategory.westren: 'images/map_icons/western.png',
  StoreCategory.fastfood: 'images/map_icons/fastfood.png',
  StoreCategory.bread: 'images/map_icons/bread.png',
  StoreCategory.pub: 'images/map_icons/pub.png',
  StoreCategory.fusion: 'images/map_icons/fusion.png',
  StoreCategory.cafe: 'images/map_icons/cafe.png',
  StoreCategory.delivery: 'images/map_icons/delivery.png',
  StoreCategory.other: 'images/map_icons/other.png',
  StoreCategory.buffet: 'images/map_icons/buffet.png',
};
Map<String, StoreCategory> indsMclsNmToCategory = {
  'Q01': StoreCategory.korean,
  'Q02': StoreCategory.chinese,
  'Q03': StoreCategory.japanese,
  'Q04': StoreCategory.snack,
  'Q05': StoreCategory.chicken,
  'Q06': StoreCategory.westren,
  'Q07': StoreCategory.fastfood,
  'Q08': StoreCategory.bread,
  'Q09': StoreCategory.pub,
  'Q10': StoreCategory.fusion,
  'Q12': StoreCategory.cafe,
  'Q13': StoreCategory.delivery,
  'Q14': StoreCategory.other,
  'Q15': StoreCategory.buffet
};

const double lowLimit = 54.5;
const double upThresh = 100;
const double waiting = 150;
const double boundary = 500;
const double downThresh = 550;
const double highLimit = 600;

const double searchRowHeight = 40;

List<String> sampleImages = [
  "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
  "https://wallpaperaccess.com/full/2637581.jpg",
  "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg"
];
Object notificationMock = {
  "major_type": "reserve",
  "message": "안녕하세요.",
  "on_click_event_type": "reserve_accepted",
  "store_id": "6wteBwHq84hQooJrDlDd",
  "table": 2,
  "time": 1231241,
};
