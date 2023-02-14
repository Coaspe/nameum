import 'package:json_annotation/json_annotation.dart';
part 'store_in_radius.g.dart';

@JsonSerializable()
class StoreInRadius {
  /// bizedId: 상가업소번호, bizesNm: 상호명, brchNm: 지점명
  final String? bizesId, bizesNm, brchNm;

  /// indsLclsCd: 상권업종대분류코드, indsLclsNm: 상권업종대분류명, indsMclsCd: 상권업종중분류코드
  final String? indsLclsCd, indsLclsNm, indsMclsCd;

  /// indsMclsNm: 상권업종중분류명, indsSclsCd: 상권업종소분류코드, indsSclsNm: 상권업종소분류명
  final String? indsMclsNm, indsSclsCd, indsSclsNm;

  /// ksicCd: 표준산업분류코드, ksicNm: 표준산업분류명, ctprvnCd: 시도코드
  final String? ksicCd, ksicNm, ctprvnCd;

  /// ctprvnNm: 시도명, signguCd: 시군구코드, signguNm: 시군구명
  final String? ctprvnNm, signguCd, signguNm;

  /// adongCd: 행정동코드, adongNm: 행정동명, ldongCd: 법정동코드
  final String? adongCd, adongNm, ldongCd;

  /// ldongNm: 법정동명, lnoCd: PNU코드, plotSctCd: 대지구분코드
  final String? ldongNm, lnoCd, plotSctCd;

  /// plotSctNm: 대지구분명, bldMngNo: 건물관리번호, hoNo: 호정보
  final String? plotSctNm, bldMngNo, hoNo;

  /// lnoAdr: 지번주소, rdnmCd: 도로명코드, rdnm: 도로명
  final String? lnoAdr, rdnmCd, rdnm;

  /// bldNm: 건물명, rdnmAdr: 도로명주소, oldZipcd: 구우편번호
  final String? bldNm, rdnmAdr, oldZipcd;

  /// newZipcd: 신우편번호, dongNo: 동정보, flrNo: 층정보
  final String? newZipcd, dongNo, flrNo;

  /// lon: 경도, lat: 위도
  final double? lon, lat;

  /// lnoMnno: 지번본번지, lnoSlno: 지번부번지, bldMnno: 건물본번지, bldSlno: 건물부번지
  final dynamic lnoMnno, lnoSlno, bldMnno, bldSlno;

  const StoreInRadius(
    this.bizesId,
    this.bizesNm,
    this.brchNm,
    this.indsLclsCd,
    this.indsLclsNm,
    this.indsMclsCd,
    this.indsMclsNm,
    this.indsSclsCd,
    this.indsSclsNm,
    this.ksicCd,
    this.ksicNm,
    this.ctprvnCd,
    this.ctprvnNm,
    this.signguCd,
    this.signguNm,
    this.adongCd,
    this.adongNm,
    this.ldongCd,
    this.ldongNm,
    this.lnoCd,
    this.plotSctCd,
    this.plotSctNm,
    this.lnoMnno,
    this.lnoSlno,
    this.lnoAdr,
    this.rdnmCd,
    this.rdnm,
    this.bldMnno,
    this.bldSlno,
    this.bldMngNo,
    this.bldNm,
    this.rdnmAdr,
    this.oldZipcd,
    this.newZipcd,
    this.dongNo,
    this.flrNo,
    this.hoNo,
    this.lon,
    this.lat,
  );

  factory StoreInRadius.fromJson(Map<String, dynamic> json) =>
      _$StoreInRadiusFromJson(json);
  Map<String, dynamic> toJson() => _$StoreInRadiusToJson(this);
}
