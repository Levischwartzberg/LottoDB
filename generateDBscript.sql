USE [master]
GO
/****** Object:  Database [Lottery]    Script Date: 8/17/2021 5:37:32 PM ******/
CREATE DATABASE [Lottery]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Lottery', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Lottery.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Lottery_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Lottery_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Lottery] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Lottery].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Lottery] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Lottery] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Lottery] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Lottery] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Lottery] SET ARITHABORT OFF 
GO
ALTER DATABASE [Lottery] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Lottery] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Lottery] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Lottery] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Lottery] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Lottery] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Lottery] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Lottery] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Lottery] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Lottery] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Lottery] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Lottery] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Lottery] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Lottery] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Lottery] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Lottery] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Lottery] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Lottery] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Lottery] SET RECOVERY FULL 
GO
ALTER DATABASE [Lottery] SET  MULTI_USER 
GO
ALTER DATABASE [Lottery] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Lottery] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Lottery] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Lottery] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Lottery', N'ON'
GO
USE [Lottery]
GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteDrawing]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Inputs Lottery Drawing Data
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteDrawing](
	@DrawingId		int = null,
	@DrawingDate	datetime = null,
	@Jackpot		int = null,
	@GameId			int = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN

	SET NOCOUNT ON;

	if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

	--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.Drawing(
			DrawingDate,
			Jackpot,
			GameId
		)
		values(
			@DrawingDate,
			@Jackpot,
			@GameId
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.Drawing
		set		DrawingDate = isNull(@DrawingDate, DrawingDate),
				Jackpot = isNULL(@Jackpot, Jackpot),
				GameId = isNull(@GameId, GameId)
		where	DrawingId = @DrawingId;

		set	@ReturnValue = @DrawingId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.Drawing
		where	DrawingId = @DrawingId;

		set	@ReturnValue = @DrawingId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteGames]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/12/2021
-- Description:	Adds or edits lottery games
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteGames](
	@GameId			int = null,
	@GameName		varchar(50) = null,
	@Rules			varchar(1000) = null,
	@GameDescription varchar(1000) = null,
	@Cost			int = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.Games(
			GameName,
			Rules,
			GameDescription,
			Cost
		)
		values(
			@GameName,
			@Rules,
			@GameDescription,
			@Cost
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.Games
		set		GameName = isNull(@GameName, GameName),
				Rules = isNULL(@Rules, Rules),
				GameDescription = isNULL(@GameDescription, GameDescription),
				Cost = isNULL(@Cost, Cost)
		where	GameId = @GameId;

		set	@ReturnValue = @GameId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.Games
		where	GameId = @GameId;

		set	@ReturnValue = @GameId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteNumber]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Inputs Lottery Ball Data
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteNumber](
	@NumberId		int = null,
	@Number			int = null,
	@NumberTypeId	int = null,
	@DrawingId		int = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN

	SET NOCOUNT ON;

	if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

	--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.Number(
			Number,
			NumberTypeId,
			DrawingId
		)
		values(
			@Number,
			@NumberTypeId,
			@DrawingId
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.Number
		set		Number = isNull(@Number, Number),
				NumberTypeId = isNULL(@NumberTypeId, NumberTypeId),
				DrawingId = isNull(@DrawingId, DrawingId)
		where	NumberId = @NumberId;

		set	@ReturnValue = @NumberId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.Number
		where	NumberId = @NumberId;

		set	@ReturnValue = @NumberId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteNumberType]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Inputs Lottery Ball Data
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteNumberType](
	@NumberTypeId	int = null,
	@NumberType		varchar(50) = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN

	SET NOCOUNT ON;

	if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

	--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.NumberType(
			NumberType
		)
		values(
			@NumberType
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.NumberType
		set		NumberType = isNull(@NumberType, NumberType)
		where	NumberTypeId = @NumberTypeId;

		set	@ReturnValue = @NumberTypeId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.NumberType
		where	NumberTypeId = @NumberTypeId;

		set	@ReturnValue = @NumberTypeId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteOdds]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/12/2021
-- Description:	Adds or edits lottery games
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteOdds](
	@GameOddsId		int = null,
	@GameId			int = null,
	@Match			varchar(50) = null,
	@Prize			varchar(50) = null,
	@Odds			varchar(50) = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.Odds(
			GameId,
			Match,
			Prize,
			Odds
		)
		values(
			@GameId,
			@Match,
			@Prize,
			@Odds
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.Odds
		set		GameId = isNull(@GameId, GameId),
				Match = isNULL(@Match, Match),
				Prize = isNULL(@Prize, Prize),
				Odds = isNULL(@Odds, Odds)
		where	GameOddsId = @GameOddsId;

		set	@ReturnValue = @GameOddsId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.Odds
		where	GameOddsId = @GameOddsId;

		set	@ReturnValue = @GameOddsId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteStates]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/12/2021
-- Description:	Adds or edits States
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteStates](
	@StateId		int = null,
	@StateName		varchar(50),
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.States(
			StateName
		)
		values(
			@StateName
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.States
		set		StateName = isNull(@StateName, StateName)
		where	StateId = @StateId;

		set	@ReturnValue = @StateId;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.States
		where	StateId = @StateId;

		set	@ReturnValue = @StateId;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:

END
GO
/****** Object:  StoredProcedure [dbo].[usp_ExecuteStateToGame]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/12/2021
-- Description:	Adds or edits StateToGame
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExecuteStateToGame](
	@Id				int = null,
	@GameId			int = null,
	@StateId		int = null,
	@QueryId		int = 10,
	@ReturnValue	int = null output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto INSERT_ITEM end;
	if(@QueryId = 20) begin goto UPDATE_ITEM end;
	if(@QueryId = 30) begin goto DELETE_ITEM end;

	goto EXIT_SECTION;

--BEGIN: INSERT SECTION
INSERT_ITEM:
	begin
		insert into dbo.StateToGame(
			StateId,
			GameId
		)
		values(
			@StateId,
			@GameId
		)
		set @ReturnValue = SCOPE_IDENTITY();

		goto EXIT_SECTION;
	end
--END

--BEGIN: UPDATE SECTION
UPDATE_ITEM:
	begin
		update	dbo.StateToGame
		set		StateId = isNull(@StateId, StateId),
				GameId = isNull(@GameId, GameId)
		where	Id = @Id;

		set	@ReturnValue = @Id;

		goto EXIT_SECTION;
	end
--END

--BEGIN: DELETE SECTION
DELETE_ITEM:
	begin
		delete
		from	dbo.StateToGame
		where	Id = @Id;

		set	@ReturnValue = @Id;

		goto EXIT_SECTION;
	end
--END

--EXIT SECTION
EXIT_SECTION:

END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDrawing]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for Drawings
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetDrawing](
	@DrawingId			int = null,
	@DrawingDate		datetime = null,
	@GameId				int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_DATE end;
	if(@QueryId = 20) begin goto GET_MOST_RECENT end;
	if(@QueryId = 30) begin goto GET_COLLECTION_BY_GAME end;

	goto EXIT_SECTION;

--BEGIN: Get numbers by date section
GET_ITEM_BY_DATE:
	begin
		select		*
		from		dbo.Drawing d
		left join	dbo.Number n
		on			d.DrawingId = n.DrawingId
		where		d.DrawingDate = @DrawingDate
		and			d.GameId = @GameId;

		goto EXIT_SECTION;
	end
--END: Get numbers by date section

--BEGIN: Get most recent numbers by game
GET_MOST_RECENT:
	begin
		select		top 1 *
		from		dbo.Drawing d
		left join	dbo.Number n
		on			d.DrawingId = n.DrawingId
		where		d.GameId = @GameId
		order by	d.DrawingDate desc;

		goto EXIT_SECTION;
	end
--END: Get most recent numbers by game

--BEGIN: Get client collection
GET_COLLECTION_BY_GAME:
	begin
		select		*
		from		dbo.Drawing d
		left join	dbo.Number n
		on			d.DrawingId = n.DrawingId
		where		d.GameId = @GameId
		order by	d.DrawingDate desc;		

		goto EXIT_SECTION;
	end
--END: Get client collection

--EXIT
EXIT_SECTION:

END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetGames]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for Games
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetGames](
	@GameId			int = null,
	@GameName		varchar(50) = null,
	@QueryId		int = null,
	@ReturnValue	int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_ID end;
	if(@QueryId = 20) begin goto GET_ITEM_BY_NAME end;
	if(@QueryId = 30) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get item by id section
GET_ITEM_BY_ID:
	begin
		select	*
		from	dbo.Games g
		where	g.GameId = @GameId;

		goto EXIT_SECTION;
	end
--END: Get item by id section

--BEGIN: Get item by name section
GET_ITEM_BY_NAME:
	begin
		select	*
		from	dbo.Games g
		where	g.GameName = @GameName;

		goto EXIT_SECTION;
	end
--END: Get item by name section

--BEGIN: Get client collection
GET_COLLECTION:
	begin
		select		*
		from		dbo.Games g
		order by	g.GameName;

		goto EXIT_SECTION;
	end
--END: Get client collection

--EXIT
EXIT_SECTION:

END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetNumber]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for Drawings
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetNumber](
	@NumberId			int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_ID end;
	if(@QueryId = 20) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get number by id
GET_ITEM_BY_ID:
	begin
		select		*
		from		dbo.Number n
		where		n.NumberId = @NumberId;

		goto EXIT_SECTION;
	end
--END: Get number by id

--BEGIN: Get all numbers
GET_COLLECTION:
	begin
		select		*
		from		dbo.Number;

		goto EXIT_SECTION;
	end
--END: Get all numbers

--EXIT
EXIT_SECTION:

END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetNumberType]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for Number Type
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetNumberType](
	@NumberTypeId		int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_ID end;
	if(@QueryId = 20) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get number type by id
GET_ITEM_BY_ID:
	begin
		select		*
		from		dbo.NumberType n
		where		n.NumberTypeId = @NumberTypeId;

		goto EXIT_SECTION;
	end
--END: Get number type by id

--BEGIN: Get all number types
GET_COLLECTION:
	begin
		select		*
		from		dbo.NumberType;

		goto EXIT_SECTION;
	end
--END: Get all number types

--EXIT
EXIT_SECTION:

END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetOdds]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for Odds
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetOdds](
	@GameId				int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_GAME end;
	if(@QueryId = 20) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get odds by game id
GET_ITEM_BY_GAME:
	begin
		select		*
		from		dbo.Odds o
		where		o.GameId = @GameId;

		goto EXIT_SECTION;
	end
--END: Get odds by game id

--BEGIN: Get all odds
GET_COLLECTION:
	begin
		select		*
		from		dbo.Odds;

		goto EXIT_SECTION;
	end
--END: Get all odds

--EXIT
EXIT_SECTION:

END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetState]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for States
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetState](
	@StateId			int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_ITEM_BY_ID end;
	if(@QueryId = 20) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get state by id
GET_ITEM_BY_ID:
	begin
		select		*
		from		dbo.States s
		where		s.StateId = @StateId;

		goto EXIT_SECTION;
	end
--END: Get state by id

--BEGIN: Get all states
GET_COLLECTION:
	begin
		select		*
		from		dbo.States;

		goto EXIT_SECTION;
	end
--END: Get all states

--EXIT
EXIT_SECTION:

END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetStatesAndGames]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Levi Schwartzberg
-- Create date: 8/17/2021
-- Description:	Get Methods for StateToGame
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetStatesAndGames](
	@StateId			int = null,
	@GameId				int = null,
	@QueryId			int = null,
	@ReturnValue		int = null output		
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@QueryId = 10) begin goto GET_GAMES_BY_STATE end;
	if(@QueryId = 20) begin goto GET_STATES_BY_GAME end;
	if(@QueryId = 30) begin goto GET_COLLECTION end;

	goto EXIT_SECTION;

--BEGIN: Get games by state
GET_GAMES_BY_STATE:
	begin
		select		s.StateName,
					g.GameName
		from		dbo.StateToGame sg
		left join	dbo.States s
		on			s.StateId = sg.StateId
		left join	dbo.Games g
		on			g.GameId = sg.GameId
		where		sg.StateId = @StateId;

		goto EXIT_SECTION;
	end
--END: Get games by state

--BEGIN: Get games by states
GET_STATES_BY_GAME:
	begin
		select		s.StateName,
					g.GameName
		from		dbo.StateToGame sg
		left join	dbo.States s
		on			s.StateId = sg.StateId
		left join	dbo.Games g
		on			g.GameId = sg.GameId
		where		sg.GameId = @GameId;

		goto EXIT_SECTION;
	end
--END: Get games by states

--BEGIN: Get all
GET_COLLECTION:
	begin
		select		s.StateName,
					g.GameName
		from		dbo.StateToGame sg
		left join	dbo.States s
		on			s.StateId = sg.StateId
		left join	dbo.Games g
		on			g.GameId = sg.GameId;

		goto EXIT_SECTION;
	end
--END: Get all

--EXIT
EXIT_SECTION:

END

GO
/****** Object:  Table [dbo].[Drawing]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drawing](
	[DrawingId] [int] IDENTITY(1,1) NOT NULL,
	[DrawingDate] [datetime] NULL,
	[Jackpot] [bigint] NULL,
	[GameId] [int] NULL,
 CONSTRAINT [PK_Drawing] PRIMARY KEY CLUSTERED 
(
	[DrawingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Games]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Games](
	[GameId] [int] IDENTITY(1,1) NOT NULL,
	[GameName] [varchar](50) NOT NULL,
	[Rules] [varchar](1000) NULL,
	[GameDescription] [varchar](1000) NULL,
	[Cost] [int] NULL,
 CONSTRAINT [PK_Games] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Number]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Number](
	[NumberId] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NULL,
	[NumberTypeId] [int] NULL,
	[DrawingId] [int] NULL,
 CONSTRAINT [PK_Number] PRIMARY KEY CLUSTERED 
(
	[NumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NumberType]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NumberType](
	[NumberTypeId] [int] IDENTITY(1,1) NOT NULL,
	[NumberType] [varchar](50) NULL,
 CONSTRAINT [PK_NumberType] PRIMARY KEY CLUSTERED 
(
	[NumberTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Odds]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Odds](
	[GameOddsId] [int] IDENTITY(1,1) NOT NULL,
	[GameId] [int] NOT NULL,
	[Match] [varchar](50) NULL,
	[Prize] [varchar](50) NULL,
	[Odds] [varchar](50) NULL,
 CONSTRAINT [PK_Odds] PRIMARY KEY CLUSTERED 
(
	[GameOddsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[States]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[States](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](50) NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StateToGame]    Script Date: 8/17/2021 5:37:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateToGame](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StateId] [int] NULL,
	[GameId] [int] NULL,
 CONSTRAINT [PK_StateToGame] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [FK_GameOdds_GameId]    Script Date: 8/17/2021 5:37:32 PM ******/
CREATE NONCLUSTERED INDEX [FK_GameOdds_GameId] ON [dbo].[Odds]
(
	[GameOddsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_GameToGameId]    Script Date: 8/17/2021 5:37:32 PM ******/
CREATE NONCLUSTERED INDEX [FK_GameToGameId] ON [dbo].[StateToGame]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [FK_StateToStateId]    Script Date: 8/17/2021 5:37:32 PM ******/
CREATE NONCLUSTERED INDEX [FK_StateToStateId] ON [dbo].[StateToGame]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Drawing]  WITH CHECK ADD  CONSTRAINT [FK_Drawing_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO
ALTER TABLE [dbo].[Drawing] CHECK CONSTRAINT [FK_Drawing_Game]
GO
ALTER TABLE [dbo].[Number]  WITH CHECK ADD  CONSTRAINT [FK_Number_Drawing] FOREIGN KEY([DrawingId])
REFERENCES [dbo].[Drawing] ([DrawingId])
GO
ALTER TABLE [dbo].[Number] CHECK CONSTRAINT [FK_Number_Drawing]
GO
ALTER TABLE [dbo].[Number]  WITH CHECK ADD  CONSTRAINT [FK_Number_NumberType] FOREIGN KEY([NumberTypeId])
REFERENCES [dbo].[NumberType] ([NumberTypeId])
GO
ALTER TABLE [dbo].[Number] CHECK CONSTRAINT [FK_Number_NumberType]
GO
ALTER TABLE [dbo].[Odds]  WITH CHECK ADD  CONSTRAINT [FK_GameOdds_GameId] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO
ALTER TABLE [dbo].[Odds] CHECK CONSTRAINT [FK_GameOdds_GameId]
GO
ALTER TABLE [dbo].[StateToGame]  WITH CHECK ADD  CONSTRAINT [FK_StateToGame_GameId] FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([GameId])
GO
ALTER TABLE [dbo].[StateToGame] CHECK CONSTRAINT [FK_StateToGame_GameId]
GO
ALTER TABLE [dbo].[StateToGame]  WITH CHECK ADD  CONSTRAINT [FK_StateToGame_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO
ALTER TABLE [dbo].[StateToGame] CHECK CONSTRAINT [FK_StateToGame_StateId]
GO
USE [master]
GO
ALTER DATABASE [Lottery] SET  READ_WRITE 
GO
