--  Synthesis context.
--  Copyright (C) 2017 Tristan Gingold
--
--  This file is part of GHDL.
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston,
--  MA 02110-1301, USA.

with Synth.Environment; use Synth.Environment;
with Synth.Values; use Synth.Values;
with Simul.Environments; use Simul.Environments;
with Netlists; use Netlists;
with Netlists.Builders;
with Vhdl.Nodes; use Vhdl.Nodes;

package Synth.Context is
   --  Values are stored into Synth_Instance, which is parallel to simulation
   --  Block_Instance_Type.
   type Objects_Array is array (Object_Slot_Type range <>) of Value_Acc;

   type Synth_Instance_Type (Max_Objs : Object_Slot_Type) is record
      --  Module which owns gates created for this instance.
      M : Module;

      --  Name prefix for declarations.
      Name : Sname;

      --  The corresponding instance from simulation.
      Sim : Block_Instance_Acc;

      --  Instance for synthesis.
      Objects : Objects_Array (1 .. Max_Objs);
   end record;

   type Synth_Instance_Acc is access Synth_Instance_Type;

   type Instance_Map_Array is array (Block_Instance_Id range <>)
     of Synth_Instance_Acc;
   type Instance_Map_Array_Acc is access Instance_Map_Array;

   --  Map between simulation instance and synthesis instance.
   Instance_Map : Instance_Map_Array_Acc;

   --  Global context.
   Build_Context : Netlists.Builders.Context_Acc;

   --  Create and free the corresponding synth instance.
   function Make_Instance (Sim_Inst : Block_Instance_Acc)
                          return Synth_Instance_Acc;
   procedure Free_Instance (Synth_Inst : in out Synth_Instance_Acc);

   --  Build the value for object OBJ.
   --  KIND must be Wire_Variable or Wire_Signal.
   procedure Make_Object (Syn_Inst : Synth_Instance_Acc;
                          Kind : Wire_Kind;
                          Obj : Iir);

   --  Get the value of OBJ.
   function Get_Value (Inst : Synth_Instance_Acc; Obj : Iir) return Value_Acc;

   --  Get a net from a scalar/vector value.  This will automatically create
   --  a net for literals.
   function Get_Net (Val : Value_Acc) return Net;
end Synth.Context;
