unit uFrameCustom;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  sFrameAdapter;

type
  TCustomInfoFrame = class(TFrame)
    sFrameAdapter1: TsFrameAdapter;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AfterCreation; virtual; // Вызывается после создания frame
    procedure BeforeDestruct;    virtual;
    procedure AfterSkinChange; virtual;
    procedure BeforeSkinChange; virtual;
    procedure SkinActiveChanged; virtual;
    // Called when SkinManager.Active switched on/off
  end;

implementation

{$R *.dfm}

uses uMainForm;

{ TCustomInfoFrame }

procedure TCustomInfoFrame.AfterCreation;
begin
 //
end;

procedure TCustomInfoFrame.AfterSkinChange;
begin
//
end;

procedure TCustomInfoFrame.BeforeDestruct;
begin
//
end;

procedure TCustomInfoFrame.BeforeSkinChange;
begin
 //
end;

procedure TCustomInfoFrame.SkinActiveChanged;
begin
 //
end;

end.
