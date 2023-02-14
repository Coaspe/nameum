import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Address {
  final String? detBdNmList, engAddr, rn;
  final String? emdNm, zipNo, roadAddrPart2;
  final String? emdNo, sggNm, jibunAddr;
  final String? siNm, roadAddrPart1, bdNm;
  final String? admCd, udrtYn, lnbrMnnm;
  final String? roadAddr, lnbrSlno, buldMnnm;
  final String? bdKdcd, liNm, rnMgtSn;
  final String? mtYn, bdMgtSn, buldSlno;

  const Address(
      {this.detBdNmList,
      this.engAddr,
      this.rn,
      this.emdNm,
      this.zipNo,
      this.roadAddrPart2,
      this.emdNo,
      this.sggNm,
      this.jibunAddr,
      this.siNm,
      this.roadAddrPart1,
      this.bdNm,
      this.admCd,
      this.udrtYn,
      this.lnbrMnnm,
      this.roadAddr,
      this.lnbrSlno,
      this.buldMnnm,
      this.bdKdcd,
      this.liNm,
      this.rnMgtSn,
      this.mtYn,
      this.bdMgtSn,
      this.buldSlno});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
