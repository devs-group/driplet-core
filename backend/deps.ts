import express from "npm:express@4.18.2";
import expressSession from "npm:express-session@1.18.1";
import passport from "npm:passport@0.7.0";
import { Strategy as GoogleStrategy } from "npm:passport-google-oauth20@2.0.0";
import pino from "npm:pino@9.5.0";

export { express, expressSession, GoogleStrategy, passport, pino };
