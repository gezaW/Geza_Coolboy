unit OrdermanConst;

interface

type

  TOrdermanRegistrationRecord = record
    FIndex: Integer;
    FFirma: Integer;
    FSerialNumber: Integer;
    FDescription: String;
    FStationID: Integer;
  end;

  //25.06.2010 BW: Enum for all possible OrdermanForms (Classic and Hermes)
  TOrdermanForms = (FormDownload, FormLoginName, FormLoginPassword, FormTables, FormTable, FormReversal,
                    FormBill, FormTransfer, FormTransferTables, FormTransferRooms, FormTransferGuests,
                    FormPrinters, FormFreeTextInput, FormSystem, FormTableSearch);

  //11.08.2010 BW: Enum for all possible TableTypes
  TTableTypes = (TableTypeNormal, TableTypeRegularGuest, TableTypeCredit, TableTypeRoom, TableTypeAdvertising,
                 TableTypeStaff, TableTypeSelfConsumption, TableTypeLeakage, TableTypeStock);

  //25.06.2010 BW: imported from Global.pas
  TTischart = (TT_Alle, TT_Offen, TT_Belegt, TT_Split, TT_SplitOffen,
               TT_FelixZimmer, TT_AlleGaeste, TT_ZimmerIntern);


implementation

end.
